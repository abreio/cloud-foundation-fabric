#!/bin/sh

# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$0")")
TFDOC_CMD="${SCRIPT_DIR}/tfdoc.py"
CHECKDOC_CMD="${SCRIPT_DIR}/check_documentation.py"
if [ -z "$PYTHON" ]; then
	PYTHON=python
fi

for file in "$@"; do
	if [ -d "${file}" ]; then
		dir="${file}"
	else
		dir=$(dirname "${file}")
	fi
	if [ -f "${dir}/README.md" ] && [ -f "${dir}/main.tf" ]; then
		echo "${dir}"
	fi

done | sort | uniq | while read -r line; do /bin/sh -c "echo ${PYTHON} \"${TFDOC_CMD}\" \"$line\" ; ${PYTHON} \"${TFDOC_CMD}\" \"$line\" ; echo ${PYTHON} \"${CHECKDOC_CMD}\" \"$line\" ; ${PYTHON} \"${CHECKDOC_CMD}\" \"$line\""; done
