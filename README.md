About
-----
These scripts are part of `hits` pipeline for DNA resequencing, which are used to identify sector variant.

filter_vcf.pl
-------------------------
```
Usage: filter_vcf.pl vcf_file <DP> <IMF> <AF1> <DP4>
 e.g.: filter_vcf.pl sector.vcf 20 0.85 0.90 0.80
```

vcfcmp
---------------
```
 Usage: vcfcmp ref.vcf var.vcf
  e.g.: vcfcmp WT.vcf MU.vcf
```

Sclerotinia sclerotiorum
------------------------
- For _Sclerotinia sclerotiorum_, use vcfcmp.ss and filter_vcf.ss.pl, please.

Author
------
Qinhu Wang (wangqinhu@nwafu.edu.cn)

Copyright
---------
2017 (c) Xu Lab, Northwest A&F University

License
-------

MIT
