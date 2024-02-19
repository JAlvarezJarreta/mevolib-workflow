// See the NOTICE file distributed with this work for additional information
// regarding copyright ownership.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

process GET_INFERENCE {
    tag "$file_path"
    publishDir "${params.output_dir}/inference", mode: 'copy', overwrite: false

    input:
        tuple path(file_path), val(file_format)

    output:
        tuple path("*_inference.${params.inference_out_format}"), val("${params.inference_out_format}")

    shell:
        '''
        get_inference -t !{params.inference_tool} -i !{file_path} --informat !{file_format} \
            --outformat !{params.inference_out_format}
        '''
}
