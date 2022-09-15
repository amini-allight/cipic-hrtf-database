Table of Contents of the CIPIC HRTF Database Files
Release 1.1
October 21, 2001

This directory contains data files, documentation, and utility programs
for Release 1.0 of the CIPIC HRTF database. An overview of the
measurement methods and of the content of the CIPIC HRTF database is
presented in the paper ``The CIPIC HRTF database'' also included in
this WASPAA'01 CD-ROM.

For more information, demos, and data updates check out our web site at

http://interface.cipic.ucdavis.edu/

There are four directories in the database:
  1. standard_hrir_database
  2. special_kemar_hrir
  3. anthropometry
  4. doc

1. The standard_hrir_database directory contains all the subject
HRIR data. Subject_021 is KEMAR with large pinnae and subject_165 is
KEMAR with small pinnae. The subdirectory show_data contains a MATLAB
program of the same name. Run show_data within this subdirectory to
display and analyze the HRIRs and HRTFs for each subject. (Another
MATLAB program called hor_show_data is convenient for inspecting the
data in the horizontal plane.)

2. The special_kemar_hrir directory includes two non-standard KEMAR
datasets for HRIRs measured in the horizontal and the frontal planes.
HRIRs are provided for both the large and the small pinnae.

3. The anthropometry directory includes the anthropometry data and a
brief readme file on data formats.

4. The doc directory includes several documents. They are:
   * Documentation for the UCD HRIR files. The documentation includes
     descriptions of the geometry and coordinate systems. 
   * The user manual for the  show_data program.
   * Description of the anthropometric parameters in the database. 
   

_____________________________________________________________________

NOTICES


Sponsorship
-----------

  This work was supported by the National Science Foundation under Grants
  IRI-9619339 and ITR-0086075. Any opinions, findings and conclusions or
  recommendations expressed in this material are those of the authors, and
  do not necessarily reflect the views of the National Science Foundation.


System Requirements
-------------------

  The programs and data files use three-dimensional MATLAB arrays, and
  thus require MATLAB 5.x or higher. It has been tested primarily on
  PC platforms under Linux and Windows 9x, and may have to be modified
  to run on other computing systems. Although we welcome reports of
  problems or suggestions for enhancements, no support of any kind can
  be provided.


Copyright
---------

Copyright (c) 2001 The Regents of the University of California. All Rights Reserved


Disclaimer
---------

THE REGENTS OF THE UNIVERSITY OF CALIFORNIA MAKE NO REPRESENTATION OR 
WARRANTIES WITH RESPECT TO THE CONTENTS HEREOF AND SPECIFICALLY DISCLAIM ANY 
IMPLIED WARRANTIES OR MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE.

Further, the Regents of the University of California reserve the right to 
revise this software and/or documentation and to make changes from time to 
time in the content hereof without obligation of the Regents of the University 
of California to notify any person of such revision or change.


Use of Materials
----------------
                        
The Regents of the University of California hereby grant users permission to 
reproduce and/or use materials available therein for any purpose- educational, 
research or commercial. However, each reproduction of any part of the 
materials must include the copyright notice, if it is present.

In addition, as a courtesy, if these materials are used in published research, 
this use should be acknowledged in the publication. If these materials are 
used in the development of commercial products, the Regents of the University 
of California request that written acknowledgment of such use be sent to:

     CIPIC- Center for Image Processing and Integrated Computing
     University of California
     1 Shields Avenue
     Davis, CA 95616-8553



