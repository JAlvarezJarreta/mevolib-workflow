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

include { validateParameters; paramsHelp; paramsSummaryLog } from 'plugin/nf-validation'

// Print help message, supply typical command line usage for the pipeline
if (params.help) {
   log.info paramsHelp('nextflow run main.nf --species "Ixodes scapularis" --seq_type mitochondrion --cluster_tool genes --align_tool mafft --inference_tool fasttree')
   exit 0
}

// Validate input parameters
validateParameters()

// Print summary of supplied parameters
log.info paramsSummaryLog(workflow)

// Parse parameters further
if (params.query) {
    entrez_query = "'${params.query}'"
} else {
    entrez_query = ""
    if (params.species != null) {
        entrez_query = "'\"${params.species}\"[Organism]"
        // Add the sequence type of the query (if provided)
        if (params.seq_type) {
            entrez_query += " AND ${params.seq_type}[filter]"
        }
        // Add the reference sequence of the query (if provided)
        if (params.refseq) {
            entrez_query += " AND RefSeq[filter]"
        }
        entrez_query += "'"
    }
}

// Import modules/subworkflows
include { FETCH_SEQS } from '../modules/fetch_seqs.nf'
include { GET_GENES } from '../modules/get_genes.nf'
include { GET_ALIGN } from '../modules/get_align.nf'
include { GET_INFERENCE } from '../modules/get_inference.nf'

// Named workflow for pipeline
workflow MEVOLIB {
    if (params.input_file) {
        file_ch = Channel.fromPath(params.input_file)
        format_ch = Channel.value(params.input_format)
        seqs_ch = file_ch
            .combine(format_ch)
    } else {
        query_ch = Channel.value(entrez_query)
        seqs_ch = FETCH_SEQS(query_ch)
    }

    if (params.cluster_tool) {
        // Since seqs_ch will only have one value, we can assign the output directly to the same channel
        seqs_ch = GET_GENES(seqs_ch)
    }

    if (params.align_tool) {
        msa_ch = GET_ALIGN(seqs_ch)
    } else {
        msa_ch = seqs_ch
    }

    if (params.inference_tool) {
        GET_INFERENCE(msa_ch)
    }
}