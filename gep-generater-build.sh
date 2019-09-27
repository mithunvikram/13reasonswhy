#!/bin/bash

BASEPATH='/var/jenkins_home/workspace/gep-dev-system-entry-pod/geppettotest'

GENERATIONMANAGERCODE='/var/jenkins_home/workspace/gep-dev-system-entry-pod/geppettotest/generator/services/generation-manager'
GENERATIONMANAGERIMAGENAME='tharanirajan/gep-dev-generationmanager:1.0'

CONFIGURATIONMANAGERCODE='/var/jenkins_home/workspace/gep-dev-system-entry-pod/geppettotest/generator/services/configurationmanager'
CONFIGURATIONMANAGERIMAGENAME='tharanirajan/gep-dev-configmanager:1.0'


GENERATIONMANAGERIMAGE=$(sudo docker images | awk '{ print $1,$2 }' | grep tharanirajan/gep-dev-generationmanager | awk '{print $1 }')
CONFIGURATIONMANAGERIMAGE=$(sudo docker images | awk '{ print $1,$2 }' | grep tharanirajan/gep-dev-configmanager | awk '{print $1 }')


echo "Started build for generation pod....."


update_code () {

cd $BASEPATH

git pull
if [ $? -eq 0 ]; then
    echo "Code updated sucessfully....."
else
    echo "git pull failed!"
fi

}

delete_if_existing_generation_manager () {

if [ ! "$GENERATIONMANAGERIMAGE" ];
then
  echo "gep-dev-generationmanager:1.0 Image is not available"
else
  echo "Deleting gep-dev-generationmanager:1.0 Image"
  sudo docker rmi -f $GENERATIONMANAGERIMAGENAME
  echo "Deleted...."
fi

}

build_and_push_image_generation_manager () {

cd $GENERATIONMANAGERCODE
sudo docker build -t $GENERATIONMANAGERIMAGENAME .
if [ $? -eq 0 ]; then
    echo "image build sucessfully"
    sudo docker push $GENERATIONMANAGERIMAGENAME
    if [ $? -eq 0 ]; then
        echo "image gep-dev-generationmanager:1.0 pushed sucessfully"
    else
        echo "image gep-dev-generationmanager:1.0 push failed"
    fi
else
    echo "gep-dev-generationmanager:1.0 image build failed"
fi

}

delete_if_existing_configuration_manager () {

if [ ! "$CONFIGURATIONMANAGERIMAGE" ];
then
  echo "gep-dev-configmanager:1.0 Image is not available"
else
  echo "Deleting gep-dev-configmanager:1.0 Image"
  sudo docker rmi -f $CONFIGURATIONMANAGERIMAGENAME
  echo "Deleted...."
fi

}

build_and_push_image_configuration_manager () {

cd $CONFIGURATIONMANAGERCODE

sudo docker build -t $CONFIGURATIONMANAGERIMAGENAME .
if [ $? -eq 0 ]; then
    echo "image build sucessfully"
    sudo docker push $CONFIGURATIONMANAGERIMAGENAME
    if [ $? -eq 0 ]; then
        echo "image gep-dev-configmanager:1.0 pushed sucessfully"
    else
        echo "image gep-dev-configmanager:1.0 push failed"
    fi
else
    echo "gep-dev-configmanager:1.0 image build failed"
fi

}



update_code
delete_if_existing_configuration_manager
build_and_push_image_configuration_manager
delete_if_existing_generation_manager
build_and_push_image_generation_manager