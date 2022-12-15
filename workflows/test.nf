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


workflow {
    genes = FETCH_SEQS()
    GET_GENES(genes)
}
