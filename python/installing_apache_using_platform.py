import platform
import subprocess
import sys


def apache_installation():
    try:
        #First step is to detect the operating system
        os_info = platform.platform()

        #After checking the operating system, install the OS based on that
        if "Ubuntu" in os_info:
            subprocess.check_call(['sudo', 'apt-get', 'update'])
            subprocess.check_call(['sudo', 'apt-get', '-y', 'install','apache2'])
        elif "centos" in os_info:
            subprocess.check_call(['sudo', 'yum','-y', 'update'])
            subprocess.check_call(['sudo', 'yum', '-y', 'install','httpd'])
        else:
            print("Unsupported operating system")
            sys.exit(1)
        
        print("Apache installed sucessfully")

    except subprocess.CalledProcessError as e:
        print(f"Error occured while installing apache: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"An unexpected error occur: {e}")
        sys.exit(1)

apache_installation()