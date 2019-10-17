# asymtree.pl
Program to calculate gene tree spectrum for an asymmetric rooted four-taxon species tree

This program calculates the expected gene tree spectrum for the rooted species tree (((AB)C)D);

Simply invoke the program as follows:

./asymtree.pl <T2> <T3>\n";

Where T2 and T3 are branch lengths in coalescent units. T2 is the length of the branch uniting
taxa A and B; T3 is the length of the branch uning taxa A, B, and C. In newick format, the tree
would be (((A,B):T3, C):T2, D);

The output is a list of the 15 possible gene trees with the expected proportion of gene trees
with that topology. For example, running the program with T2 = T3 = 0.5 yields:

# Species tree:
#  (((A,B):0.5, C):0.5, D)
#
# Expected proportion of each gene tree:
#   ((AB)(CD)) -- 0.133345019529159
#   ((AC)(BD)) -- 0.0537946133487619
#   ((AD)(BC)) -- 0.0537946133487619
# * (((AB)C)D) -- 0.321437560953448
#   (((AB)D)C) -- 0.12582639268268
  (((AC)B)D) -- 0.0870690330268755
  (((AC)D)B) -- 0.0462759865022834
  (((AD)B)C) -- 0.00751862684647848
  (((AD)C)B) -- 0.00751862684647848
  (((BC)A)D) -- 0.0870690330268755
  (((BC)D)A) -- 0.0462759865022834
  (((BD)A)C) -- 0.00751862684647848
  (((BD)C)A) -- 0.00751862684647848
  (((CD)A)B) -- 0.00751862684647848
  (((CD)B)A) -- 0.00751862684647848
  
The asterisk indicated the speciodendric gene tree. The expected proportions of each gene tree
are calculated using the equations in Table V of Rosenberg (2002).

Rosenberg, N. A. (2002). The probability of topological concordance of gene trees and species trees. 
Theoretical population biology, 61(2), 225-247.
