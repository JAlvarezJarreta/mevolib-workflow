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

// Arguments for alignment process
// if(params.tool == null){
//     tool = "mafft"
// } else{
//     tool = params.tool
// }

workflow {
    // genes = FETCH_SEQS(total_query, params.name)
    FETCH_SEQS(total_query, params.name)
    // file = GET_GENES(genes, params.name)
    GET_GENES(FETCH_SEQS.out.gb_gile, params.name)
    // GET_ALIGN(tool, file.flatten, params.name)
    GET_GENES.out.gene_files.view()
    GET_ALIGN(GET_GENES.out.gene_files)
}