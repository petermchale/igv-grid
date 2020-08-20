from cyvcf2 import VCF
import sys 

variants = VCF(sys.argv[1])
for variant in variants:
  chromosome = variant.CHROM
  start = variant.POS - 1
  end = variant.INFO.get('END')
  if not end:
    end = variant.POS + len(variant.REF) - 1 # VCF 4.2
  print('{}\t{}\t{}\n'.format(chromosome, start, end), end='')
variants.close()
