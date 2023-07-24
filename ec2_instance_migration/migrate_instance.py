import boto3
from botocore.exceptions import BotoCoreError, ClientError
import json
from datetime import datetime
import time

ec2 = boto3.resource("ec2")

def create_ami(instance_id):
    try:
        instance=ec2.Instance(instance_id)
        print(f'Stopping instance {instance_id}...')
        instance.stop()
        instance.wait_until_stopped()
        print(f'Instance {instance_id} stopped.')
        timestamp = datetime.now().strftime('%Y%m%d%H%M%S')
        image = instance.create_image(Name=f'Creating AMI for {instance_id} at {timestamp}')
        print(f'Creating image for instance {instance_id}...')
        image.wait_until_exists()
        while image.state == 'pending':
            print('Waiting for image to become available...')
            time.sleep(10)
            image.reload()
        print(f'Sucessfully create image {image.id} using instance {instance_id}')
        print(f'Starting instance {instance_id}...')
        instance.start()
        instance.wait_until_running()
        print(f'Instance {instance_id} started.')
        
        return image.id
    except BotoCoreError as e:
        print(f'There is an error from Botocore during image creation: {e}')
    except ClientError as e:
        print(f'There is an error from AWS during image creation: {e}')        
    except Exception as e:
        print(f'Error: Due AMI creation: {e}')

def create_ec2_instance(image_id, instance_type):
    try:
        print(f'Creating instance from image {image_id}...')
        instances = ec2.create_instances(
            ImageId=image_id,
            InstanceType=instance_type,
            MinCount=1,
            MaxCount=1
        )
        instance = instances[0]
        instance.wait_until_running()
        print(f'Successfully created instance {instance.id} with type {instance_type}')
    except BotoCoreError as e:
        print(f'Error from BotoCore on instance creation: {e}')
    except ClientError as e:
        print(f'Error from AWS on instance creation: {e}')
    except Exception as e:
        print(f'Unexpected error on instance creation: {e}')


try:
    with open('migrate_instance.json','r') as f:
        data = json.load(f)
        for item in data:
            image_id = create_ami(item['instance_id'])
            if image_id:
                create_ec2_instance(image_id, item['instance_type'])
except FileNotFoundError:
    print("The file migrate_instance.json was not found")
except json.JSONDecodeError:
    print("There was an error decoding json from file migrate_instance.json")    
except Exception as e:
    print(f'Unexpected error: {e}')            
