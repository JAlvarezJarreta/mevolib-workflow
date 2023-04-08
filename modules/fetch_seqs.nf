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
    // debug true

    input:
    val total_query
    val name

    output:
    path "${name}.gb"

    shell:
    """
    fetch_genbank_seqs -q "$total_query" -n "$name"
    """
}

workflow {
    if (params.name == null){
        print("Please, insert the file name to fetch")
        exit(1)
    }

    //Completed query
    if(params.query != null && params.species != null){
        print("Please, insert either the query or the specie")
        exit(1)
    }
    //Query or species needed
    else if(params.query == null && params.species == null){
        print("Please, insert the query or the specie")
        exit(1)
    }
    //Species of the query (mandatory)
    else if(params.query == null && params.species != null) {
        total_query = "(\"${params.species}\"[Organism] OR ${params.species}[All Fields])"

        //Sequence type of the query (optional)
        if(params.seq_type != null){
            total_query += " AND ${params.seq_type}[PROP]"
        }

        //Reference sequence of the query (optional)
        if(params.ref_seq != null){
            total_query += " AND ${params.ref_seq}[filter]"
        }
    }
    //Example of a completed query: 
    //  '(\"${Ixodes}\"[Organism] OR ${ixodes}[All Fields]) AND (biomol_genomic[PROP] AND refseq[filter])'
    else if(params.query != null && params.species == null) {
        total_query = params.query
    }
    
    genes = FETCH_SEQS(total_query, params.name)
}