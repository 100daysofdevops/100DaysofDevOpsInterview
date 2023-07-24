# AWS EC2 Instance Migration Script

This repository contains a Python script that automates the process of migrating AWS EC2 instances from one instance type to another.

## Overview
The script works by:

1. Reading a JSON file that contains the instance IDs and the instance types to migrate to.
2. For each instance, the script does the following:
* Stops the instance.
* Creates an AMI (Amazon Machine Image) from the instance.
* Waits for the AMI to become available.
* Starts the instance again.
* Creates a new instance from the AMI with the specified type.
* Waits for the new instance to start.

## Prerequisites
* Python 3
* Boto3 library
* AWS account with appropriate permissions to stop and start instances, create AMIs, and create instances.

## Usage

Install the necessary Python library if you haven't done so:
```pip install boto3```

Clone the repository:
```git clone https://github.com/yourusername/yourrepository.git```

Update the JSON file with the instance IDs and instance types you want to migrate to.


## Run the script:
```python migrate_instances.py migrate_instances.json```

🚨Remember that stopping and starting instances, creating AMIs, and creating new instances may result in additional costs and temporary unavailability of the instances. Always consider these factors and your application's requirements before performing these operations.

## License
This project is licensed under the terms of the MIT license.
