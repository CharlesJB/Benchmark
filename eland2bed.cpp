/**
 * \File eland2bed.cpp
 *
 * \Author Charles Joly Beauparlant
 *
 * \Date 2012-02-15
 */

#include <iostream>
#include <fstream>
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <stdexcept>
#include <stdlib.h>

using namespace std;

void convertElandLineToBed(char* line);
int getPositionEnd(char* positionBegin, char* sequence);

int main(int argc, char* argv[]) {
	if (argc == 2) {
		// 1. Open file
		ifstream in(argv[1], ifstream::in);

		// 2. For each line in the file
		if (in.is_open()) {
			char line[2048];
			while (in.getline(line, 2047)) {
			// 2.1 Convert to bed	
				convertElandLineToBed(line);
			}
		}
	}
	else { // if (argc != 2)
		// Print usage
		cout << "eland2bed usage:" << endl;
		cout << "eland2bed <ElandFileName>" << endl;
	}
	return 0;
}

void convertElandLineToBed(char* line) {
	char junk[256];
	char sequence[1024];
	char chromosome[256];
	char positionBegin[256];
	char strand[256];

	// 1. Scan line
	sscanf(line, "%s %s %s %s %s %s %s %s %s", junk, sequence, junk, junk, junk, junk, chromosome, positionBegin, strand);

	// 2. Print infos in bed format
	cout << "chr" << chromosome << "\t";
	cout << positionBegin << "\t";
	cout << getPositionEnd(positionBegin, sequence) << "\t";
	if (strcmp(strand, "F") == 0) cout << "+\n";
	else if (strcmp(strand, "R") == 0) cout << "-\n";
	else throw logic_error("Incorrect value for strand position.");
}

int getPositionEnd(char* positionBegin, char* sequence) {
	// 1. Get the length of the sequence
	int seqLength = (int)strlen(sequence);

	// 2. Convert positionBegin to int
	int i_positionBegin = atoi(positionBegin);

	// 3. Add length of sequence to positionBegin
	return i_positionBegin + seqLength;
}
