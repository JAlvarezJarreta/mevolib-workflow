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

nextflow.enable.dsl = 2

// Import modules/subworkflows
include { FETCH_SEQS } from '../modules/fetch_seqs.nf'
include { GET_GENES } from '../modules/get_genes.nf'
include { GET_ALIGN } from '../modules/get_align.nf'

//Name of the output file
if (params.name == null){
    print("Please, insert the file name")
    exit(1)
}

//Query or species needed
if(params.query != null && params.species != null){
    print("Please, insert either the query or the specie")
    exit(1)
}

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

// //Arguments for Align
if(params.tool == null){
    params.tool = 'mafft'
}

workflow {
    genes = FETCH_SEQS(total_query, params.name)
    file = GET_GENES(genes, params.name)
    GET_ALIGN(params.tool, file, params.name)
}