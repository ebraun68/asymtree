# Programs used in Tiley et al. (2020)
-----------------------------------------
Tiley, G. P., Pandey, A., Kimball, R. T., Braun, E. L. & Burleigh, J. G. (2020). Whole 
genome phylogeny of Gallus: Introgression and data-type effects. Avian Research 11: 7.
https://doi.org/10.1186/s40657-020-00194-w

-----------------------------------------
"asymtree.pl" returns the expected gene tree spectrum for an asymmetric rooted four-taxon species 
tree. It calculates the expected gene tree spectrum for the rooted species tree (((AB)C)D);

Simply invoke the program as follows:

./asymtree.pl T2 T3

Where T2 and T3 are branch lengths in coalescent units. T2 is the length of the branch uniting
taxa A and B; T3 is the length of the branch uning taxa A, B, and C. In newick format, the tree
would be (((A,B):T3, C):T2, D);

The output is a list of the 15 possible gene trees with the expected proportion of gene trees
with that topology. For example, running the program with T2 = T3 = 0.5 implies the following
species tree:

- (((A,B):0.5, C):0.5, D)

And it will yield the following list of gene trees:

- ((AB)(CD)) -- 0.133345019529159
- ((AC)(BD)) -- 0.0537946133487619
- ((AD)(BC)) -- 0.0537946133487619
- (((AB)C)D) -- 0.321437560953448 (speciodendric gene tree)
- (((AB)D)C) -- 0.12582639268268
- (((AC)B)D) -- 0.0870690330268755
- (((AC)D)B) -- 0.0462759865022834
- (((AD)B)C) -- 0.00751862684647848
- (((AD)C)B) -- 0.00751862684647848
- (((BC)A)D) -- 0.0870690330268755
- (((BC)D)A) -- 0.0462759865022834
- (((BD)A)C) -- 0.00751862684647848
- (((BD)C)A) -- 0.00751862684647848
- (((CD)A)B) -- 0.00751862684647848
- (((CD)B)A) -- 0.00751862684647848
  
The speciodendric gene tree is indicated using an asterisk. The expected proportions of each gene
tree are calculated using the equations in Table V of Rosenberg (2002).

Rosenberg, N. A. (2002). The probability of topological concordance of gene trees and species trees. 
Theoretical population biology, 61(2), 225-247. https://doi.org/10.1006/tpbi.2001.1568

In addition to asymtree.pl, I provide a simple perl script called symtree.pl that perfoms the same
calculation for a symmetric species tree. It was not used in Tiley et al. (2020) because the Gallus
species tree is asymmetric, but it is provided because it may be useful to others.

symtree.pl is used in the same way as asymtree.pl. Obviously, the values for T2 and T3 are mapped
onto the species tree in a different manner (because the topology is different). In the case of
symtree.pl they map onto the tree as follows:

(((A,B):T3+T2, (C,D)):T2)

If you have a rooted four-taxon species tree with coalescent branch lengths simply use the shorter
branch length as T2 and set T3 to the longer branch length minus T2.

-----------------------------------------
"perfect_sites.pl" is a simple program that extracts "perfect sites" from a relaxed phylip format
input file (assumed to comprise only the parsimony informative sites). We define perfect sites as
parsimony informative sites in columns with only two states and no gaps.

It is straightforard to run; simply invoke the program as follows: 

./perfect_sites.pl infile outfile

NOTE: outfile is simply a prefix. The program actually generates two nexus files (see below)
  
The output is two nexus files, one for all perfect sites (outfile.all.nex) and a second nexus
file (outfile.tv.nex) with purines and pyrimidines coded as 0 and 1, respectively. The binary
coding will render some sites uninformative; this can be addressed by opening the .tv.nex file in
PAUP*, excluding uninformative sites, and exporting a new file.

-----------------------------------------
"perfect_Gallus_tv2tree.pl" is used to convert perfect transversions into partially resolved gene
trees. This program is "hard wired" in that it assumes the following five taxa:

Btho = Bambusicola thoracicus (Chinese bamboo partridge)
Gvar = Gallus varius (Green junglefowl)
Ggal = Gallus gallus (Red junglefowl)
Gson = Gallus sonneratii (Grey junglefowl)
Glaf = Gallus lafayetii (Sri Lankan junglefowl)

The program will read a relaxed phylip format infile with binary (RY) data and convert the data
to bipartition strings, which correspond to the following trees:

- 00111 = (Btho,Gvar,(Ggal,Gson,Glaf));
- 01011 = (Btho,Ggal,(Gvar,Gson,Glaf));
- 01101 = (Btho,Gson,(Gvar,Ggal,Glaf));
- 01110 = (Btho,Glaf,(Gvar,Ggal,Gson));
- 00011 = (Btho,Gvar,Ggal,(Gson,Glaf));
- 00110 = (Btho,Gvar,Glaf,(Ggal,Gson));
- 01100 = (Btho,Gson,Glaf,(Gvar,Ggal));
- 01010 = (Btho,Ggal,Glaf,(Gvar,Gson));
- 01001 = (Btho,Ggal,Gson,(Gvar,Glaf));
- 00101 = (Btho,Gvar,Gson,(Ggal,Glaf));
		
Thee first 0 in the bipartition string represents the state in Btho (either R or Y) and subsequent 
0/1 indicators provide information regarding the state in the four junglefowl species. The taxon order 
in all strings is Btho Gvar Ggal Gson Glaf

The trees were used as input for ASTRAL III (Zhang et al. 2018).

Zhang, C., Rabiee, M., Sayyari, E., & Mirarab, S. (2018). ASTRAL-III: polynomial time species tree 
reconstruction from partially resolved gene trees. BMC bioinformatics, 19(6), 153.
