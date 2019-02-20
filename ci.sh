#!/bin/bash

npm install git+https://git@github.com/starburst997/lix.client.git --global

lix download

haxe test.hxml -D reporter=test.XUnit2Reporter -D report-name=Test-Results-$AGENT_OS
