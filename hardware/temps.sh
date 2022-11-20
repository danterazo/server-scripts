#!/bin/bash
### script to show temperature sensor data

## load kernel driver
sudo modprobe drivetemp

## print
sensors
