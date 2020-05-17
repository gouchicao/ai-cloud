#!/usr/bin/python

import sys
import getpass
from fabric import Connection, Config


# 您要远程操作的计算机，username@ip
hosts = [
    'pi@rpi1',
    'pi@rpi2',
    'pi@rpi3']

if __name__ == '__main__':
    cmd = 'uname -a'
    if len(sys.argv) == 2:
        cmd = sys.argv[1]

    sudo_pass = getpass.getpass("What's your sudo password?")
    config = Config(overrides={'sudo':{'password':sudo_pass}})

    for host in hosts:
        if sudo_pass:
            Connection(host, config=config).sudo(cmd, hide='stderr')
        else:
            Connection(host).run(cmd)
