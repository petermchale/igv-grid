set -o xtrace 

srun \
  --time=1:00:00 \
  --cpus-per-task=16 \
  --mem=10g \
  --account=redwood-gpu \
  --partition=redwood-gpu \
  --pty /bin/bash
