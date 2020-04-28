#!/usr/bin/env python

import re
import subprocess


def execute_cmd(cmd):
    print(cmd)
    proc = subprocess.Popen(cmd,
                            shell=True,
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE)
    print(proc)
    comm = proc.communicate()

    if comm[1] != b'':
        print(comm[1])
        exit(-1)

    return str(comm[0], 'utf-8')


def generate_secret_key():
    login_cmd = execute_cmd('aws ecr get-login --no-include-email').rstrip('\n')
    creds = re.sub(r"(docker login\ |-u\ |-p\ )",
                   '',
                   login_cmd).split(' ')
    generate_secret_cmd = "\
        kubectl create \
        secret docker-registry {0} \
        --docker-username={1} \
        --docker-password={2} \
        --docker-server={3} \
        -o yaml \
        --dry-run | \
        kubectl apply -f -"
    execute_cmd(generate_secret_cmd.format('ecr-docker-config',
                                           creds[0],
                                           creds[1],
                                           creds[2].replace('https://', '')))


if __name__ == "__main__":
    generate_secret_key()
