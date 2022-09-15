The variables within the database file are described in the anthropometry.pdf
file located in the top-level "doc" folder. These variables are as follows:

  D			45x16	- cols 1:8 left ear, 9:16 right ear
  WeightKilograms	45x1  
  X			45x17    
  age			45x1  
  id			45x1  
  sex			45x1
  theta			45x4	- cols 1:2 left ear, 3:4 right ear

Each row contains data for a single subject. 
When there is more than one column, each column corresponds
to the variable described in the Anthropometry.pdf file. 

There is both left and right data in the arrays D and theta.
In both cases, the left values are given first.


For example:

   id(4) returns the subject number "10".
   Therefore, X(4,3) is x3, the head depth, for subject number 10.

   D(4,2) is d2, cymba concha height, left ear of subject number 10.
   Since there are 8 D values, the right-ear data is displaced by 8.
   This makes D(4,10) the cymba concha height for the right ear 
   of subject number 10.

Note!! Not all the data is available or relevant for every subject.  
       When numeric data is not available, the placeholder is NaN.  
       For strings, the placeholder is the null character, string(0).
