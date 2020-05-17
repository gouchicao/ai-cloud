import sys

from fabric import SerialGroup


hosts = [
    'pi@rpi1',
    'pi@rpi2',
    'pi@rpi3']

if __name__ == '__main__':
    cmd = 'uname -a'
    if len(sys.argv) == 2:
        cmd = sys.argv[1]
        
    pool = SerialGroup(*hosts)
    pool.run(cmd)
