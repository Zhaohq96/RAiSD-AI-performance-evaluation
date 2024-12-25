#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>

int Find_Max_index (double *p, int samples) // function for pccs-based strategies to find the index of row or column has maximum 1s
{
	int i;
	int Maxid=0;
	for(i=0;i<samples;i++)
	{
		if(p[Maxid]<p[i])Maxid=i;
	}
	return Maxid;
}

char ** Row (char **p, int samples, int sites) // function of rowed frequency-based sorting 
{
	int m,n;
	int *count = (int*)malloc(sizeof(int)*samples);
	
	for(m=0;m<samples;m++)
	{
		count[m] = 0;
		for(n=0;n<sites;n++)
		{
			if(p[m][n] == 49)count[m]++;
		}
	}
	
	int temple;
	char *temp;
	
	for(m=0;m<samples;m++)
	{
		for(n=m+1;n<samples;n++)
		{
			if(count[m] < count[n])
			{
				temp = p[m];
				p[m] = p[n];
				p[n] = temp;
	
				temple = count[m];
				count[m] = count[n];
				count[n] = temple;
			}
		}
	}
	
	for(m=0;m<samples;m++)
	{
		printf("%d\n", count[m]);
	}
	
	free(count);
	
	return p;
}

char ** Column (char **p, int samples, int sites) // function of columned frequency-based sorting
{
	int k,m,n;
	int *count = (int*)malloc(sizeof(int)*sites);
		
	for(m=0;m<sites;m++)
	{
		count[m] = 0;
		for(n=0;n<samples;n++)
		{
			if(p[n][m] == 49)count[m]++;
		}
	}
	

		
	int temple;
	char temp;
		
	for(m=0;m<sites;m++)
	{
		for(n=m+1;n<sites;n++)
		{
			if(count[m] < count[n])
			{
				for(k=0;k<samples;k++)
				{
					temp = p[k][m];
					p[k][m] = p[k][n];
					p[k][n] = temp;
				}
					
				temple = count[m];
				count[m] = count[n];
				count[n] = temple;
			}
		}
	}
	
	for(k=0;k<sites;k++)
	{
		printf("%d\n", count[k]);
	}
	
	free(count);
	
	return p;
}

char ** Pccrow (char **p, int samples, int sites) // function of rowed pccs-based sorting
{
	int *P_A = (int*)calloc(samples, sizeof(int));
	int *P_a = (int*)calloc(samples, sizeof(int));
	int i,k,m,n;
		
	for(i=0;i<samples;i++)
	{
		for(k=0;k<sites;k++)
		{
			if(p[i][k] == 49)P_A[i]++;
		}
		P_a[i] = sites - P_A[i];
//		printf("%d %d\n", P_A[i], P_a[i]);
	}
		
	// create the matrices to store PCC between two rows and the sum of PCC of each row
	double **PCC_matrix = (double**)malloc(sizeof(double*)*samples);
	double *sum = (double*)calloc(samples, sizeof(double));

		
	for(i=0;i<samples;i++)
	{
		PCC_matrix[i] = (double*)malloc(sizeof(double)*(samples));
	}
		
	for(i=0;i<samples;i++)
	{
		PCC_matrix[i][i] = 1.000001;
		for(k=i+1;k<samples;k++)
		{
			int P_AB=0;
			for(m=0;m<sites;m++)
			{
				if(p[i][m] == 49 && p[k][m] == 49)P_AB++;
			}
			PCC_matrix[i][k] = (double)((double)P_AB/(double)sites-(double)P_A[i]/(double)sites*(double)P_A[k]/(double)sites)*((double)P_AB/(double)sites-(double)P_A[i]/(double)sites*(double)P_A[k]/(double)sites)/(double)(P_A[i]/(double)sites*(double)(1-(double)P_A[i]/(double)sites)*(double)P_A[k]/(double)sites*(double)(1-(double)P_A[k]/(double)sites));
			if(P_A[i] == 0 || P_A[k] == 0)PCC_matrix[i][k]=0;
			//PCC_matrix[k][i] = PCC_matrix[i][k];
			PCC_matrix[k][i] = PCC_matrix[i][k];
//			printf("%d %d %d %d %d %d ", P_AB, sites, P_A[i], P_A[k], P_a[i], P_a[k]);
//			printf("%f\n", PCC_matrix[i][k]);
		}
	}
		
	for(i=0;i<samples;i++)
	{
		for(k=0;k<samples;k++)
		{
			sum[i]+=PCC_matrix[i][k];
//			printf("%lf ", PCC_matrix[i][k]);
		}
//		printf("%lf\n", sum[i]);
	}
		
	int Maxid=0;
		
	// find the max index and sort with row
	Maxid = Find_Max_index(sum, samples);
//	printf("%d %lf\n", Maxid, sum[Maxid]);
		
	double temple1;
	char *temp1;
		
	for(m=0;m<samples;m++)
	{
		for(n=m+1;n<samples;n++)
		{
			if(PCC_matrix[Maxid][m] < PCC_matrix[Maxid][n])
			{
				temp1 = p[m];
				p[m] = p[n];
				p[n] = temp1;
					
				temple1 = PCC_matrix[Maxid][m];
				PCC_matrix[Maxid][m] = PCC_matrix[Maxid][n];
				PCC_matrix[Maxid][n] = temple1;
			}
		}
	}
	
	free(P_A);
	free(P_a);
	free(sum);
	for(i=0;i<samples;i++)
	{
		free(PCC_matrix[i]);
	}
	free(PCC_matrix);
	
	return p;
}

char ** Pcccolumn (char **p, int samples, int sites) // function of columned pccs-based sorting
{
	int *P_A = (int*)calloc(sites, sizeof(int));
	int *P_a = (int*)calloc(sites, sizeof(int));
	int i,k,m,n;
		
	for(i=0;i<sites;i++)
	{
		for(k=0;k<samples;k++)
		{
			if(p[k][i] == 49)P_A[i]++;
		}
		P_a[i] = samples - P_A[i];
//		printf("%d %d\n", P_A[i], P_a[i]);
	}
		
	double **PCC_matrix = (double**)malloc(sizeof(double*)*sites);
	double *sum = (double*)calloc(sites, sizeof(double));

		
	for(i=0;i<sites;i++)
	{
		PCC_matrix[i] = (double*)malloc(sizeof(double)*(sites));
	}
		
	for(i=0;i<sites;i++)
	{
		PCC_matrix[i][i] = 1.000001;
		for(k=i+1;k<sites;k++)
		{
			int P_AB=0;
			for(m=0;m<samples;m++)
			{
				if(p[m][i] == 49 && p[m][k] == 49)P_AB++;
			}
			PCC_matrix[i][k] = (double)((double)P_AB/(double)samples-(double)P_A[i]/(double)samples*(double)P_A[k]/(double)samples)*((double)P_AB/(double)samples-(double)P_A[i]/(double)samples*(double)P_A[k]/(double)samples)/(double)(P_A[i]/(double)samples*(double)(1-(double)P_A[i]/(double)samples)*(double)P_A[k]/(double)samples*(double)(1-(double)P_A[k]/(double)samples));
			if(P_A[i] == 0 || P_A[k] == 0)PCC_matrix[i][k]=0;
			PCC_matrix[k][i] = PCC_matrix[i][k];
//			printf("%d %d %d %d %d %d ", P_AB, samples, P_A[i], P_A[k], P_a[i], P_a[k]);
//			printf("%f\n", PCC_matrix[i][k]);
		}
	}
		
	for(i=0;i<sites;i++)
	{
		for(k=0;k<sites;k++)
		{
			sum[i]+=PCC_matrix[i][k];
//			printf("%lf ", PCC_matrix[i][k]);
		}
//		printf("%lf\n", sum[i]);
	}
		
	int Maxid=0;

	Maxid = Find_Max_index(sum, sites);
//	printf("%d %lf\n", Maxid, sum[Maxid]);
		
	double temple;
	char temp;
		
	for(m=0;m<sites;m++)
	{
		for(n=m+1;n<sites;n++)
		{
			if(PCC_matrix[Maxid][m] < PCC_matrix[Maxid][n])
			{
				for(k=0;k<samples;k++)
				{
					temp = p[k][m];
					p[k][m] = p[k][n];
					p[k][n] = temp;
				}
					
				temple = PCC_matrix[Maxid][m];
				PCC_matrix[Maxid][m] = PCC_matrix[Maxid][n];
				PCC_matrix[Maxid][n] = temple;
			}
		}
	}
	
	free(P_A);
	free(P_a);
	free(sum);
	for(i=0;i<sites;i++)
	{
		free(PCC_matrix[i]);
	}
	free(PCC_matrix);
	
	return p;
}


int main (int argc, char ** argv)
{
	int opt;
	const char *optstring = "i:m:c:w:s:l:r:g:o:";
	int  win_snp=0, win_site=0, length=0, min_snp=1, grid_size=1;
	char *mode, *outname;
	char *center;
	char *file_name;
	mode = "noopt";
	center = "noopt";
	
	while (-1 != (opt = getopt(argc, argv, optstring))) // get opts
	{
		switch (opt) {
			case 'i': ;
				file_name = optarg;
				break;
			case 'm': ;
				mode = optarg;
				break;
			case 'c': ;
				center = optarg;
				break;
			case 'w':
				win_snp = atoi(optarg);
				break;
			case 's':
				win_site = atoi(optarg);
				break;
			case 'l':
				length = atoi(optarg);
				break;
			case 'r':
				min_snp = atoi(optarg);
				break;
			case 'g':
				grid_size = atoi(optarg);
				break;
			case 'o': ;
				outname = optarg;
				break;
			default:
				printf("No option is detected");
				break;
		}
	}
	
	FILE *fp = fopen(file_name, "r");	
	FILE *fout = NULL;
	char tstring [1000000];
	char sstring [1000];
	char filename [20];
	char flag [100];
	sprintf(filename, "%s", outname);
	fout = fopen(filename, "w");
	int samples, populations;
	int skip;
	
	fscanf(fp, "%s", flag);
	
	if(strcmp(flag, "command:") == 0)
	{
		fscanf(fp, "%s", tstring);
		fprintf(fout, "./ms ");
		fscanf(fp, "%s", tstring);
		fprintf(fout, "%s ", tstring);
		samples = atoi(tstring);
		printf("number of samples: %d\n", samples);
		for(skip=0;skip<10;skip++)fscanf(fp, "%s", tstring);
		populations = atoi(tstring);
		//populations = 1000;
		fprintf(fout, "%d ", populations);
		printf("number of populations: %d\n", populations);
	}
	else
	{
		fprintf(fout, "%s ", flag);
		fscanf(fp, "%s", tstring);
		fprintf(fout, "%s ", tstring);			
		// get the number of samples
		samples = atoi(tstring);
		printf("number of samples: %d\n", samples);
		fscanf(fp, "%s", tstring);
		populations = atoi(tstring);
		fprintf(fout, "%s ", tstring);
		//fscanf(fp, "%s", tstring);
		//fprintf(fout, "%s ", tstring);
		
		//get the number of populations
		
		printf("number of populations: %d\n", populations);
	}
	
	if(win_site>length)win_site=length;
	fgets(sstring, 1000, fp);
	fprintf(fout, "%s\n", sstring);
	int j;
	
	// scan each population
	for(j=0;j<populations;j++)
	{
		if(strcmp(flag, "command:") == 0)
		{
			while(strcmp(tstring, "d"))
			{
				fscanf(fp, "%s", tstring);
				fprintf(fout, "%s", tstring);
			}
			fgets(sstring, 1000, fp);
			fprintf(fout, "\n");
			while(strcmp(tstring, "segsites:"))
			{
				fscanf(fp, "%s", tstring);
				fprintf(fout, "%s", tstring);
			}
		}
		
		while(strcmp(tstring, "segsites:"))
		{
			fscanf(fp, "%s", tstring);
			fprintf(fout, "\n%s", tstring);
		}
		
		//printf("New population start!\n");
		
		// get the sites information of this population		
		fscanf(fp, "%s", tstring);
		int sites = atoi(tstring);
		if(strcmp(flag, "command:") == 0)sites = sites - 1;
		printf("site of the population %d is: %d\n", j+1, sites);
		//if(win_snp <= sites)fprintf(fout, " %d\n", win_snp);
		//if(win_snp > sites)fprintf(fout, " %d\n", sites);
		fprintf(fout, " %d\n", sites);

		fscanf(fp, "%s", tstring);
		fprintf(fout, "%s ", tstring);
		int i,k,index_center;
		int *positions = (int*)calloc(sites, sizeof(int));
		float *position = (float*)malloc(sizeof(float)*sites);
		int position_state = 0;
		if(strcmp(flag, "command:") == 0)
		{
			for(i=0;i<sites;i++)
			{
				fscanf(fp, "%s", tstring);
				//fscanf(fp, "%s", tstring);
				//printf("%s ", tstring);
				position[i] = (float)((float)(atoi(tstring))/(float)(length));
				//printf("%f ", position[i]);
				fprintf(fout, " %f", position[i]);
			}
		}
		else
		{	
			for(i=0;i<sites;i++)
			{
				fscanf(fp, "%s", tstring);
				//fscanf(fp, "%s", tstring);
				position[i] = atof(tstring);
				fprintf(fout, " %f", position[i]);
			}
		}
		if (position_state == 1)
		{
			break;
		}
		//printf("\n");
		fprintf(fout, "\n");
		// create the matrix to store the data and write it to the txt file
		char **matrix = (char**)malloc(sizeof(char*)*samples);
		for(i=0;i<samples;i++)
		{
			matrix[i] = (char*)malloc(sizeof(char)*(sites+1));
			fscanf(fp, "%s", matrix[i]);
			fprintf(fout, "%s\n", matrix[i]);
		}
		
		
		//if (strcmp(mode, "noopt") == 0 && strcmp(center, "noopt") == 0)
		//{
		//	printf("\nOne strategy should be specified at least\n");
		//	return -1;
		//}
		
		
		free(position);
		free(positions);
		for(i=0;i<samples;i++)
		{
			free(matrix[i]);
		}
		free(matrix);
		//printf("Population ends!\n\n");
	
	}
	fclose(fp);
	fclose(fout);

	return 0;
}
