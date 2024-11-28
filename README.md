### Background

- **Subjects**: Students living in Yeonhui-dong.
- **Issues**: Current commuting routes are poorly equipped for walking, causing inconvenience. The primary commuting routes are:
        - **Via the Underwood Memorial Hall side gate**  
          <img src="https://my-github-images.s3.us-east-2.amazonaws.com/MobSolution_UnderwoodMemorialHall.png" alt="Underwood Memorial Hall" width="300">
        - **Via the West Gate**  
          <img src="https://my-github-images.s3.us-east-2.amazonaws.com/MobSolution_WestGate.png" alt="West Gate" width="300">

---

### Proposed Solution

#### **1. Physical Improvements**
- Considered but requires significant time and financial investment.

#### **2. Shuttle Bus Expansion**
- Extend the shuttle bus routes, which previously operated only within the campus, to cover Yeonhui-dong and nearby subway stations.
- Implement demand-based operations to allow students to make ride requests.
- Maintain existing shuttle bus operating hours:
  - **08:00-11:00** and **12:30-19:00**.

---

### Implementation Details

- **Operation**:
  - Buses depart from campus, pass through Yeonhui-dong and nearby subway stations, and return to campus.
  - Use the "Y-bus" app to display real-time locations and enable a call feature for on-demand services.
  
- **App Features**:
  - Students can select departure and destination points from the 15 designated stops.
  - After making a request, students can view expected wait times, travel times, and fares.
  - Drivers receive real-time route updates based on students' requests.

- **Cost Structure**:
  - **On-campus to On-campus**: Free.
  - **On-campus to Off-campus**: 600 KRW.
          - **Reference**: Since the village bus fare within 10 km is 1200 KRW, setting the shuttle bus fare within 5 km at 600 KRW is considered reasonable.

---

### Route Adjustment Based on Demand

- **Proposed Stops**:
  - **Off-campus**: Yeonhui 3-way Intersection, Yeonhui Elementary School, Yonsei-ro Food Street, Sinchon Subway Station, and more.
  - **On-campus**: Transportation Plaza, Management Building, Woojeongwon.
  - Analyzed the boarding and alighting data of the village bus from the past year and identified 15 stops with high foot traffic.
  
- **Algorithm**:
  - Initial demand clustering using **k-means** to group students with similar departure or destination points.

---

### Survey Design

#### **Objective**:  
Evaluate the acceptability of the proposed solution versus existing commuting methods.

#### **Participants**:  
Yonsei University students (**N=100**).

#### **Alternatives**:  
Village bus, PM (Personal Mobility), Walking, Demand-based shuttle bus.

#### **Variables**:
- **Fare**: Alternative-specific variable.
- **In-Vehicle Travel Time (IVT)**: Alternative-specific variable.
- **Out-of-Vehicle Travel Time (OVT)**: Common variable.
- **Wait Time**: Common variable.

#### **Survey Attribute Levels**:
<img src="https://my-github-images.s3.us-east-2.amazonaws.com/MobSolution_SurveyAttributionLevels.png" alt="West Gate" width="300">

#### **Survey Construction**:
- To reduce the burden on respondents of answering all scenarios, we designed the survey using an orthogonal design, allowing each individual to respond to only 6 questions.
- The following SAS code is used for creating an orthogonal design:
```sas
%mkturns(3 ** 7)

%mktex(3 ** 7, n=18)
%mktblock(data=randomized, nblocks=3)
proc print; run;
```
<img src="https://my-github-images.s3.us-east-2.amazonaws.com/MobSolution_SurveyOrthogonal.png" alt="West Gate" width="300">

- **Survey Construction**:  
  [Survey Link](https://docs.google.com/forms/d/e/1FAIpQLSetR4TBAHV6a4yHwfQBMrosWr2UColrJjDMXSFV8nNagxh5MA/viewform)

---

### Survey Result Analysis
Respondents choose the alternative that maximizes their utility. Therefore, to analyze respondents' choices, it is necessary to understand how the utility of each alternative is calculated.

#### **Utility Function**:
The utility of each alternative is derived using the utility function.
The utility function (
𝑈
𝑖
𝑛
=
𝑉
𝑖
𝑛
+
𝜖
𝑖
𝑛
U 
in
​
 =V 
in
​
 +ϵ 
in
​
 ) consists of deterministic utility (
𝑉
𝑖
𝑛
=
∑
𝛽
𝑖
𝑘
𝑥
𝑖
𝑛
𝑘
V 
in
​
 =∑β 
ik
​
 x 
ink
​
 ) and stochastic utility (
𝜖
𝑖
𝑛
ϵ 
in
​
 ). The attributes we set as experimental variables—fare, in-vehicle travel time, out-of-vehicle travel time, and waiting time—are all observable attributes of deterministic utility (
𝑥
𝑖
𝑛
𝑘
x 
ink
​
 ). On the other hand, stochastic utility reflects unobservable or difficult-to-observe utility as a random variable and, thus, cannot be calculated.

#### **Logit Model**:  
The goal is to estimate the coefficients ($\beta_{ik}$) of each attribute included in the deterministic utility to understand the decision-making process influenced by certain attributes in a given situation.

Deterministic utility can be modeled using respondents' choices and the level values of each attribute, and the choice probability of each alternative can be obtained using the logit model as follows:

\[
P_{in} = \text{Prob}(\epsilon_{jn} - \epsilon_{in} \leq V_{in} - V_{jn})
\]

---

### Data Processing
1. **Transform the survey data into wide form data**
2. **Transform the wide form data into long form data**
3. **Modeling**:  
   - Error Discovered
     a. Alternative-specific variables, such as fare, impact the utility of each alternative differently.Therefore, the coefficients for alternative-specific variables must be estimated separately for each alternative. However, since we fixed Village Bus fare at 1200 KRW, the slope cannot be estimated because there is no variability in the data to infer its effect on utility. To address this problem, we decided the Village Bus fare to be included in the alternative-specific intercept, which accounts for the baseline utility of the Village Bus without analyzing the fare attribute separately.
     b. Common variables, such as waiting time, affect the utility of all alternative equally. Therefore, a single coefficient is estimated for Waiting Time, applied uniformly across all alternatives. However, since there are no level changes in Waiting Time across all alternatives, there is insufficient variability in the data to estimate its effect. To address this problem, two approaches can be tried, and the model with the smaller AIC (Akaike Information Criterion) value should be selected:
     b-1. Include Waiting Time in the Alternative-Specific Intercept: Incorporate the effect of Waiting Time into the baseline utility of each alternative, without estimating a separate coefficient for it.
     b-2. Exclude Waiting Time from the Model: Completely remove Waiting Time as an attribute from the model, assuming it either does not affect utility or cannot be sufficiently explained by the data.
     c. High correlation is expected between PM fare and in-vehicle travel time, since PM Fare is calculated as: Base Fare (600 KRW) + In-Vehicle Travel Time × 150 KRW. In such cases, the variables share overlapping information, leading to distorted coefficient estimates and reduced model reliability. To address this issue, PM Fare can be adjusted to KRW per minute. By normalizing PM Fare to a time-based rate, the relationship between the two variables is simplified, reducing redundancy and improving the independence of the variables.
     d. For demand-responsive shuttle buses, incorporating uncertainty in travel time as intervals is a reasonable modeling approach. However, since the interval width (the difference between the minimum and maximum values) remains constant across all levels, the minimum and maximum values tend to have a strong correlation. This high correlation can introduce multicollinearity into the model, reducing its reliability and interpretability. To address this problem, we treated minimum values as a common variable (applies equally across all alternatives), representing the base travel time, while trated maximum value as an alternative-specific variable to reflect uncertainty in travel time, with levels such as 5/5, 5/10, and 5/15 assigned differently to alternatives. This approach separates the effects of minimum and maximum values, reducing redundancy and improving model performance.

---

### Analysis Results

#### **Statistically Significant Variables**:

| Variable                        | Coefficient    | Interpretation                                                                 |
|---------------------------------|----------------|--------------------------------------------------------------------------------|
| **Access Time (Walking)**       | \(-0.1656\)    | Longer walking time decreases utility.                                         |
| **DRT Fare (Shuttle Bus)**      | \(-0.0014\)    | Higher fare decreases shuttle bus utility.                                     |
| **Gender: Walk (Female)**       | \(-1.0562\)    | Females have lower walking utility compared to males.                          |
| **Age: Walk**                   | \(+0.2118\)    | Older individuals prefer walking more.                                        |
| **Undergrad: PM**               | \(+1.4034\)    | Undergraduates have higher PM utility than graduate students.                 |
| **Residence Type: Walk**        | \(+0.8994\)    | Students living farther prefer walking more.                                   |
| **PM Experience: PM**           | \(+0.8378\)    | PM experience increases its utility.                                           |
| **IVT (Village Bus)**           | \(-0.1374\)    | Longer in-vehicle time decreases village bus utility.                          |
| **Walking Time (Overall)**      | \(-0.1654\)    | Increased walking time decreases overall utility.                              |

#### **Survey Limitations**:
- Some attributes lacked variation, affecting coefficient estimation.
- High correlation between fare and IVT required adjustments.

---

### Conclusion

This analysis highlights key variables affecting commuting preferences and proposes improvements through demand-responsive shuttle bus services. Further refinements in survey design can yield more robust results.
