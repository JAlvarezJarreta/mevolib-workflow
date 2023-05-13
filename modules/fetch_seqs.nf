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

/** 1) Add the fetching stage to the workflow
 * 
 * This first stage of the workflow aims to fetch all the reference mtDNA sequences (RefSeq) 
 * in GenBank for the tick genus Ixodes
 * 
 * We analyse the sequences downloaded to get basic stats using the statistics function. 
 * It returns the total number of sequences stored and the arithmetic mean of the array elements of the sequences, 
 * standard deviation of the length of the sequences, minimum and maximum values of their length.
 * 
 * Finally, all the information can be saved in a file with the SeqRecord objects in a GENBANK format
**/

nextflow.enable.dsl = 2

process FETCH_SEQS {

    input:
    val total_query
    val name

    output:
    path "${name}.gb"

    shell:
    """
    fetch_genbank_seqs -q "$total_query" -o "$name"
    """
}

workflow {
    if (params.name == null){
        print("Please, insert the file name to fetch")
        exit(1)
    }

   if (params.query == null) {
        if (params.species == null) {
            print("Please, insert either the query or the species")
            exit(1)
        } else {
            total_query = "(\"${params.species}\"[Organism] OR ${params.species}[All Fields])"
            // Add the sequence type of the query (if provided)
            if(params.seq_type != null){
                total_query += " AND ${params.seq_type}[PROP]"
            }
            // Add the reference sequence of the query (if provided)
            if(params.ref_seq != null){
                total_query += " AND ${params.ref_seq}[filter]"
            }
        }
    } else {
        if (params.species == null) {
            total_query = params.query
        } else {
            print("Please, insert either the query or the species, but not both")
            exit(1)
        }
    }
    
    genes = FETCH_SEQS(total_query, params.name)
}