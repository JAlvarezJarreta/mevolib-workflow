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

/** 1) Sequence fetching stage
 *
 * This first stage of the workflow aims to fetch all the reference mtDNA sequences (RefSeq)
 * in GenBank for the tick genus Ixodes
 *
 * We analyse the sequences downloaded to get basic stats using the statistics function.
 * It returns the total number of sequences stored and the arithmetic mean of the array elements of the sequences, 
 * standard deviation of the length of the sequences, minimum and maximum values of their length.
 *
 * Finally, all the information can be saved in a file with the SeqRecord objects in a GENBANK format.
**/

process FETCH_SEQS {
    tag "$query"
    publishDir "${params.output_dir}/fetch", mode: 'copy', overwrite: true

    input:
        val query

    output:
        tuple path('sequences.gb'), val('genbank')

    script:
        extra_args = ''
        if (params.max_seqs) {
            extra_args = "--max_seqs ${params.max_seqs}"
        }
        """
        fetch_genbank_seqs -q ${query} -o sequences ${extra_args}
        """
}
