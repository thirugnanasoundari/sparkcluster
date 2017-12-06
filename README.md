# dlk
delaware data lake for open datasets


## Create EMR
cd C:\Users\vsa716\Documents\GitHub\dlk
```
aws \
--profile GR_GG_COF_AWS_Retailbank_Dev_Developer \
cloudformation create-stack \
--stack-name RhythmEMR \
--template-body 'file://c:/Users/vsa716/OneDrive - Capital One Financial Corporation/scratchpad/emrCft.json'
```
output 
```
{
    "StackId": "arn:aws:cloudformation:us-east-1:084220657940:stack/RhythmEMR/d7cd1360-d9ec-11e7-b27d-50d501eb4c17"
}
```

set PYSPARK_DRIVER_PYTHON_OPTS='notebook'
pyspark


## learnings
parquet cannot have space in column names.
If parquet files have mixed cases, then athena cannot recognize it. Need to convert all names to lowercases.
cannot write custom udf in python. Have to create scala function and wrap it in python.

## Functions learnt
withColumnRenamed is used to rename column when writing to parquet.

## Important class of pyspark
* pyspark.sql.SparkSession Main entry point for DataFrame and SQL functionality.
* pyspark.sql.DataFrame A distributed collection of data grouped into named columns.
* pyspark.sql.Column A column expression in a DataFrame.
* pyspark.sql.Row A row of data in a DataFrame.
* pyspark.sql.GroupedData Aggregation methods, returned by DataFrame.groupBy().
* pyspark.sql.DataFrameNaFunctions Methods for handling missing data (null values).
* pyspark.sql.DataFrameStatFunctions Methods for statistics functionality.
* pyspark.sql.functions List of built-in functions available for DataFrame.
* pyspark.sql.types List of data types available.
* pyspark.sql.Window For working with window functions.*
