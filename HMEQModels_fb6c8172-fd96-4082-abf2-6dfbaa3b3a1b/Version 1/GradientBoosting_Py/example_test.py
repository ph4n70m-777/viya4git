import os
import os.path
import sys

sys.path.append('/models/resources/viya/e95dec7a-18d3-44d0-b80c-132a334da421/')

import GradientBoostingScore

import settings

settings.pickle_path = '/models/resources/viya/e95dec7a-18d3-44d0-b80c-132a334da421/'

def score_record(LOAN,MORTDUE,VALUE,YOJ,DEROG,DELINQ,CLAGE,NINQ,CLNO,DEBTINC):
    "Output: EM_EVENTPROBABILITY,EM_CLASSIFICATION"
    return GradientBoostingScore.scoreGradientBoosting(LOAN,MORTDUE,VALUE,YOJ,DEROG,DELINQ,CLAGE,NINQ,CLNO,DEBTINC)

print(score_record(44.23,110.15,183.35,123.31,38.04,84.89,138,52.06,149.92,188.65))
