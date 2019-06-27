#!/bin/bash
#conda env create -f cooltools_fresh.yml
#conda activate cooltools_fresh

cd /groups/gerlich/labinfo/environments/mirnylab/bioframe/
pip install -e .
cd /groups/gerlich/labinfo/environments/mirnylab/cooltools/
pip install -e .
cd /groups/gerlich/labinfo/environments/mirnylab/pairlib/
pip install -e .