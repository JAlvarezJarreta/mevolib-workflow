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

/** 2) Clustering stage
 *
 * This second stage of the workflow aims to divide the sequences into genes (some genes are highly
 * conserved within the same genus and can be used to find those sequences of dubious quality).
 *
**/

process GET_GENES {
    tag "$file_path"
    publishDir "${params.output_dir}/cluster", mode: 'copy', overwrite: true

    input:
        tuple path(file_path), val(file_format)

    output:
        tuple path('*.fasta'), val('fasta')

    shell:
        '''
        get_genes -i !{file_path} --format !{file_format} -o ./
        '''
}
