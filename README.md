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

