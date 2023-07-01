import subprocess
import sys

try:
    result = subprocess.run(['ls', '-l'], capture_output=True, text=True, check=True)
except subprocess.CalledProcessError as e:
    print(f"The 'ls -l' command failed with return code {e.returncode}", file=sys.stderr)
    sys.exit(e.returncode)
except Exception as e:
    print(f"An unexpected error occurred: {e}", file=sys.stderr)
    sys.exit(1)

lines = result.stdout.splitlines()
for line in lines:
    filename = line.split()[-1]
    print(filename)
