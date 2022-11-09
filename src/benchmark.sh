#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE:-$0}" )" &> /dev/null && pwd )"
PROJECT_DIR="$( cd "${SCRIPT_DIR}/.." &> /dev/null && pwd )"
YCSBC_DIR="${PROJECT_DIR}/external/YCSB-C"
YCSBC_EXE="${YCSBC_DIR}/ycsbc"
WORKLOADS_DIR="${YCSBC_DIR}/workloads"

export LD_LIBRARY_PATH="/usr/local/lib"

db_list=(
  lock_stl
  lock_stl_map
  tbb_rand
  tbb_scan
)

nthreads_list=(
  1 2 4 8
)

workload_list=(
  workloada.spec
  workloadb.spec
  workloadc.spec
  workloadd.spec
  workloade.spec
  workloadf.spec
)


for workload in "${workload_list[@]}"; do
  for db in "${db_list[@]}"; do
    for nthreads in "${nthreads_list[@]}"; do
      printf "%s," $workload $db $nthreads 
      ${YCSBC_EXE} \
        -threads $nthreads \
        -db $db \
        -P ${WORKLOADS_DIR}/$workload \
      |& tail -n +3 \
      | cut -f 4
    done
  done
done
