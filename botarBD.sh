#!/bin/bash
rake db:drop
rake db:migrate
rake db:create
