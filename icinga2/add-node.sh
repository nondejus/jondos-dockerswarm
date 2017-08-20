#!/bin/bash
docker exec icinga2 icinga2 pki ticket --cn $1
