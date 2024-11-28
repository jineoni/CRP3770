# **Demand-Responsive Shuttle Bus Expansion: A Case Study for Yeonhui-Dong**

## **Background**

### **Subjects**  
Students living in Yeonhui-dong.

### **Issues**  
Current commuting routes are poorly equipped for walking, causing inconvenience. The primary commuting routes are:  

- **Via the Underwood Memorial Hall Side Gate**
  
  <img src="https://my-github-images.s3.us-east-2.amazonaws.com/MobSolution_UnderwoodMemorialHall.png" alt="West Gate" width="300">

- **Via the West Gate**
  
  <img src="https://my-github-images.s3.us-east-2.amazonaws.com/MobSolution_WestGate.png" alt="West Gate" width="300">

---

## **Proposed Solution**

### **1. Physical Improvements**  
- Considered but requires significant time and financial investment.

### **2. Shuttle Bus Expansion**  
- Extend the shuttle bus routes, which previously operated only within the campus, to cover Yeonhui-dong and nearby subway stations.
- Implement demand-based operations to allow students to make ride requests.
- Maintain existing shuttle bus operating hours:
  - **08:00-11:00** and **12:30-19:00**.

---

## **Implementation Details**

### **Operation**  
- Buses depart from campus, pass through Yeonhui-dong and nearby subway stations, and return to campus.  
- Use the **Y-bus app** to display real-time locations and enable a call feature for on-demand services.

### **App Features**  
- Students can:
  - Select departure and destination points from the **15 designated stops**.
  - View expected wait times, travel times, and fares after making a request.
- Drivers receive **real-time route updates** based on students' requests.

### **Cost Structure**  
- **On-campus to On-campus**: Free.  
- **On-campus to Off-campus**: 600 KRW.  
  - **Reference**: Since the village bus fare within 10 km is 1200 KRW, setting the shuttle bus fare within 5 km at 600 KRW is considered reasonable.

---

## **Route Adjustment Based on Demand**

### **Proposed Stops**  
- **Off-campus**: Yeonhui 3-way Intersection, Yeonhui Elementary School, Yonsei-ro Food Street, Sinchon Subway Station, and more.  
- **On-campus**: Transportation Plaza, Management Building, Woojeongwon.

### **Demand Clustering Algorithm**  
- Analyzed the past year’s village bus boarding and alighting data to identify **15 stops with high foot traffic**.  
- Used **k-means clustering** to group students with similar departure or destination points.

---

## **Survey Design**

### **Objective**  
Evaluate the acceptability of the proposed solution versus existing commuting methods.

### **Participants**  
100 Yonsei University students.

### **Alternatives**  
Village Bus, PM (Personal Mobility), Walking, and Demand-Based Shuttle Bus.

### **Variables**  

| **Variable**                 | **Type**                 |
|------------------------------|--------------------------|
| **Fare**                     | Alternative-specific     |
| **In-Vehicle Travel Time**   | Alternative-specific     |
| **Out-of-Vehicle Travel Time** | Common variable         |
| **Wait Time**                | Common variable          |

### **Survey Attribute Levels**
<img src="https://my-github-images.s3.us-east-2.amazonaws.com/MobSolution_SurveyAttributionLevels.png" alt="West Gate" width="300">

### **Survey Construction**  
- To reduce the burden on respondents of answering all scenarios, an **orthogonal design** was used, allowing each individual to respond to **6 questions**.  
- SAS code for creating the orthogonal design:
  ```sas
  %mkturns(3 ** 7);
  %mktex(3 ** 7, n=18);
  %mktblock(data=randomized, nblocks=3);
  proc print; run;

<img src="https://my-github-images.s3.us-east-2.amazonaws.com/MobSolution_SurveyOrthogonal.png" alt="West Gate" width="300">

- **Survey Construction**:  
  [Survey Link](https://docs.google.com/forms/d/e/1FAIpQLSetR4TBAHV6a4yHwfQBMrosWr2UColrJjDMXSFV8nNagxh5MA/viewform)

---

### **Survey Result Analysis**

#### **Utility Function**

The utility of each alternative is calculated as:

U_in = V_in + ε_in

Where:

- V_in = Σ β_ik x_ink: Deterministic utility based on observable attributes (fare, IVT, OVT, waiting time).
- ε_in: Stochastic utility reflecting unobservable factors.

#### **Logit Model**

The choice probability for each alternative is modeled as:

P_in = Prob(ε_jn - ε_in ≤ V_in - V_jn)

---

### **Data Processing**

#### **Steps**

1. Transform the survey data into **wide form data**.
2. Convert the **wide form data into long form data** for modeling.

---

### **Model Adjustments**

#### **1. Village Bus Fare**

**Problem**: The Village Bus fare was fixed at 1200 KRW, resulting in no variability in the fare attribute. Without level changes, it was impossible to estimate a slope for this variable.  
**Solution**: The fare was incorporated into the **alternative-specific intercept**, capturing its effect on utility without explicitly estimating a separate coefficient.

#### **2. Waiting Time**

**Problem**: Waiting time lacked level changes across all alternatives, making it impossible to estimate a slope or coefficient.  
**Solution**: Two approaches were tested:

1. Include waiting time in the alternative-specific intercept.
2. Exclude waiting time from the model entirely.  
   The model with the smaller **Akaike Information Criterion (AIC)** was selected.

#### **3. PM Fare and In-Vehicle Travel Time (IVT) Correlation**

**Problem**: The PM fare is calculated as Base Fare (600 KRW) + In-Vehicle Travel Time × 150 KRW. This created a strong correlation between PM fare and IVT, leading to multicollinearity.  
**Solution**: PM fare was normalized to **KRW per minute** to reduce redundancy and improve interpretability.

#### **4. Shuttle Bus IVT Intervals**

**Problem**: The interval width for in-vehicle travel time was constant, causing a high correlation between minimum and maximum values.  
**Solution**:

- The **minimum value** was treated as a **common variable**, representing the baseline travel time.
- The **maximum value** was treated as an **alternative-specific variable**, categorized into levels (e.g., 5/5, 5/10, 5/15) to capture variability in travel time uncertainty.

---

### **Analysis Results**

#### **Statistically Significant Variables**

| **Variable**                 | **Coefficient** | **Interpretation**                                                      |
|------------------------------|----------------|------------------------------------------------------------------------|
| **Access Time (Walking)**    | -0.1656        | Longer walking time decreases utility.                                 |
| **DRT Fare (Shuttle Bus)**   | -0.0014        | Higher fare decreases shuttle bus utility.                             |
| **Gender: Walk (Female)**    | -1.0562        | Females have lower walking utility compared to males.                  |
| **Age: Walk**                | +0.2118        | Older individuals prefer walking more.                                 |
| **Undergrad: PM**            | +1.4034        | Undergraduates have higher PM utility than graduate students.          |
| **Residence Type: Walk**     | +0.8994        | Students living farther prefer walking more.                           |
| **PM Experience: PM**        | +0.8378        | PM experience increases its utility.                                   |
| **IVT (Village Bus)**        | -0.1374        | Longer in-vehicle time decreases village bus utility.                  |
| **Walking Time (Overall)**   | -0.1654        | Increased walking time decreases overall utility.                      |

---

### **Conclusion**

This analysis highlights key factors influencing commuting preferences and demonstrates the potential benefits of demand-responsive shuttle bus services. Further refinement in survey design can enhance model reliability and insights.
