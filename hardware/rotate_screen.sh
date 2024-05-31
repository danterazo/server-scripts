#!/bin/bash

## input / arguments
orientation=${1:-1}

echo $orientation | sudo tee /sys/class/graphics/fbcon/rotate_all
