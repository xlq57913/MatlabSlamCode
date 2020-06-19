# MatlabSlamCode
Code for Slam project of SJTU Matlab Course.

---

## Contents

[toc]

---

## About Entry

> Feature matching codes are in **Odometry/FeatureMatch**

### Feature detect
edit images path and run **testORB.m** to see the results of Feature detect of a giving image.

### Feature match
edit images path and run **trial_2.m** to see the results of Extract and Match Feature Points.

#### Parameter edit
change the **excepted number of Feature Points** in **para.m**.
change the **Thresholds of Feature match** in **violent_match.m**.

### slamtb quick usage
> in matlab prompt

```matlab
>> cd slamtb-graph/slamtb-ekf % or just double click to enter the folder

>> slamrc       % load parameter

>> slamtb_graph % for slamtb-graph

% or

>> slamtb       % for slamtb-ekf
```

---

## About TODO
- [x] 视觉里程计
- [x] 利用slamtb搭建地图
- [ ] 卡尔曼滤波
- [x] 非线性优化
- [x] 特征点匹配算法优化

## About SlamToolBox

the slamtb is downloaded from github: [joansola](https://github.com/joansola/slamtb)

> slamtb-graph & slamtb-ekf are two corresponding branches of this repo

---

## About Ignore

To avoid unnecessary files in this repo, .mat files and all images are ignored, everything in figure folder are ignored, place images as you want.

---

## About Collaborators

Work by hwk, qk, xjx, zzh in SJTU Matlab Course: **(2019-2020-2)-ME391-1-Matlab及其工程应用**
