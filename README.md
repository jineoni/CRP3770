### Background

- **Subjects**: Students living in Yeonhui-dong.
- **Issues**:
    1. Current commuting routes are poorly equipped for walking, causing inconvenience.
    2. Primary commuting routes:
        - **Via the Underwood Memorial Hall side gate**  
          <img src="https://my-github-images.s3.us-east-2.amazonaws.com/MobSolution_UnderwoodMemorialHall.png" alt="Underwood Memorial Hall" width="300">

        - **Via the West Gate**  
          <img src="https://prod-files-secure.s3.us-west-2.amazonaws.com/db5c33d0-e510-4667-b185-b03bb446fb45/27071694-b5ee-45e7-9330-ef4734c540fe/Untitled.png" alt="West Gate" width="300">

---

### Proposed Solution

#### **1. Physical Improvements**
- Considered but requires significant time and financial investment.

#### **2. Shuttle Bus Expansion**
- Extend routes to cover Yeonhui-dong and nearby subway stations.
- Implement demand-based operations.
- Maintain existing shuttle bus operating hours:
  - **08:00-11:00** and **12:30-19:00**.

---

### Implementation Details

- **Current Operation**:
  - Buses depart from campus, pass through Yeonhui-dong and subway stations, and return to campus.
  - Use the "Y-bus" app to display real-time locations and enable a call feature for on-demand services.
  
- **App Features**:
  - Students can select departure and destination points (15 designated stops).
  - View expected wait times, travel times, and fares.
  - Drivers receive real-time route updates via a dedicated app.

- **Cost Structure**:
  - **On-campus to On-campus**: Free.
  - **On-campus to Off-campus**: 600 KRW.
  - **Reference**: Village bus fare within 10 km is 1200 KRW; shuttle bus fare within 5 km is set at 600 KRW.

---

### Route Adjustment Based on Demand

- **Proposed Stops**:
  - **Off-campus**: Yeonhui 3-way Intersection, Yeonhui Elementary School, Yonsei-ro Food Street, Sinchon Subway Station, and more.
  - **On-campus**: Transportation Plaza, Management Building, Woojeongwon.
  
- **Algorithm**:
  - Initial demand clustering using **k-means** to group students with similar departure or destination points.

---

### Survey Design

#### **Objective**:  
Evaluate the acceptability of the proposed solution versus existing commuting methods.

#### **Participants**:  
Yonsei University students (**N=100**).

#### **Alternatives**:  
Village bus, PM (Personal Mobility), walking, demand-based shuttle bus.

#### **Variables**:
- **Fare**: Alternative-specific.
- **In-Vehicle Travel Time (IVT)**: Alternative-specific.
- **Out-of-Vehicle Travel Time (OVT)**: Common variable.
- **Wait Time**: Common variable.

#### Survey Attribute Levels:

| Attribute       | Levels             |
|------------------|--------------------|
| **Fare (KRW)**   | 0, 600, 1200       |
| **IVT (minutes)**| 5, 10, 15          |
| **OVT (minutes)**| 2, 5, 10           |
| **Wait Time**    | 1, 3, 5            |

- **Survey Construction**:  
  [Survey Link](https://docs.google.com/forms/d/e/1FAIpQLSetR4TBAHV6a4yHwfQBMrosWr2UColrJjDMXSFV8nNagxh5MA/viewform)

---

### Survey Result Analysis

#### **Utility Function**:
The utility of each commuting method is calculated as:

\[
U_{in} = V_{in} + \epsilon_{in}
\]

- **Deterministic utility**:  
  \[
  V_{in} = \sum \beta_{ik}x_{ink}
  \]
- **Stochastic utility** (\(\epsilon_{in}\)): Reflects unobservable factors.

#### **Logit Model**:  
Choice probabilities are modeled as:

\[
P_{in} = \text{Prob}(\epsilon_{jn} - \epsilon_{in} \leq V_{in} - V_{jn})
\]

---

### Data Processing

1. **Wide to Long Data Conversion**:  
   - [Data Processing Code](https://github.com/jineoni/CRP3770/blob/main/data_processing.ipynb)

2. **Modeling**:  
   - **First Model**: [logit2.R](https://github.com/jineoni/CRP3770/blob/main/logit2.R)  
   - **Second Model**: [logit3.R](https://github.com/jineoni/CRP3770/blob/main/logit3.R)

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
