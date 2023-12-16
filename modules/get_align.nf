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

/** 3) Add the alignment stage to the workflow
 * 
 * This third stage of the workflow aims to align the genes using the given alignment tool and arguments
 * 
 * The resultant alignment is returned as a Bio.Align.MultipleSeqAlign object and saved in the output
 * file (if provided). 
**/

nextflow.enable.dsl = 2

process GET_ALIGN {
    
    publishDir "./data/${name}/align", mode: 'copy', overwrite: false
    
    input:
    path fasta
    val name

    output:
    path '*_align.fasta'
       
    shell:
    """
    get_align -t "${params.tool}" -i "$fasta" -o "$name"
    """
}


workflow {

    if (params.file == null) {
        print("Please, insert the unaligned file")
        exit(1)
    }

    read_pairs_ch = channel.fromFilePairs(params.file, checkIfExists: true)
    GET_ALIGN(params.tool, params.file, params.name)
}
