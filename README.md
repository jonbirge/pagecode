# PageCode

## Overview
Prototype capability to transfer files safely between air-gapped computers using a printer and a scanner. If you don't know why this might be useful, consider yourself lucky and your life choices wiser than mine...

## Approach
A simple binary "spread spectrum" code is used to ensure that large areas are not all ink (a consideration for inkjet printers) and to provide some level of resilience against local print or scan errors. No formal error correction is used, but is planned. Will eventually use multi-level grayscale code to improve information density.

## Usage
Right now the interface is a pretty rudimentary MATLAB script not at all suitable for public consumption. A GUI may or may not be developed at some point.
