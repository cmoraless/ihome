#!/bin/bash
rake db:drop RAILS_ENV=development
rake db:create RAILS_END=development
rake db:migrate RAILS_ENV=development

