# MatlabSlamCode
Code for Slam project of SJTU Matlab Course.

---

## About Entry

#### Feature detect
edit images path and run **testORB.m** to see the results of Feature detect of a giving image.

#### Feature match
edit images path and run **trial_2.m** to see the results of Extract and Match Feature Points.

#### Parameter edit
change the **excepted number of Feature Points** in **para.m**.
change the **Thresholds of Feature match** in **violent_match.m**.

#### slamtb quick usage
> in matlab prompt

```matlab
>> cd slamtb-graph/slamtb-ekf % or just double click to enter the folder

>> slamrc       % load parameter

>> slamtb_graph % for slamtb-graph

% or

>> slamtb       % for slamtb-ekf
```

---

## About SlamToolBox

the slamtb is downloaded from github: [joansola](https://github.com/joansola/slamtb)

> slamtb-graph & slamtb-ekf are two corresponding branches of this repo

---

## About Ignore

.mat, .fig files are ignored, everything in figure folder are ignored, place images as you want.