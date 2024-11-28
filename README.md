### Background:

- **Subjects**: Students living in Yeonhui-dong.
- **Issues**:
    - The routes students currently use for commuting are poorly equipped for walking, causing inconvenience.
    - Students primarily use two routes:
        - Via the Underwood Memorial Hall side gate.
          https://my-github-images.s3.us-east-2.amazonaws.com/MobSolution_UnderwoodMemorialHall.png
            
        - Via the West Gate.
            
            ![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/db5c33d0-e510-4667-b185-b03bb446fb45/27071694-b5ee-45e7-9330-ef4734c540fe/Untitled.png)
            

### Proposed Solution:

- **Physical Improvement**: Considered but noted to require significant time and financial investment.
- **Shuttle Bus Expansion**:
    - Extend shuttle bus routes to include Yeonhui-dong and nearby subway stations.
    - Operate buses based on real-time demand.
    - Maintain existing shuttle bus operating hours:
        - 08:00-11:00 and 12:30-19:00

### Implementation Details:

- **Current Shuttle Bus Operation**:
    - Departure from the school, passing through Yeonhui-dong and nearby subway stations, and returning to the school.
    - Use the Yonsei University transportation app "Y-bus" to display real-time bus locations and integrate a call function for demand-based operation.
- **Usage**:
    - Students can use the Y-bus app to select departure and destination points (limited to 15 designated stops).
    - Students can view expected wait times, travel times, and fares before making a call.
    - Drivers can see real-time route changes based on student demand using a dedicated app.

### Cost Structure:

- **On-campus to On-campus**: Free.
- **On-campus to Off-campus**: 600 KRW.
- **Reference**: Village bus base fare for distances within 10 km is 1200 KRW; this is why the shuttle bus fare for distances within 5 km is set at 600 KRW.

### Route Adjustment Based on Demand:

- **Stops**:
    - **Off-campus**: Yeonhui 3-way Intersection, Yeonhui Elementary School, two stops in front of Yonsei University, Sinchon Train Station, Sinchon Subway Station, Yonsei-ro Food Street, Seodaemun Post Office, two stops at Donggyo-dong Intersection.
    - **On-campus**: Transportation Plaza, Management Building, Seongam Building, Woojeongwon.
    - Selected stops have more than 1000 boarding and alighting counts on weekdays.
- **Algorithm**:
    - For the first call after the start of operations: Use k-means clustering to assign students with similar departure or destination points to the same vehicle.

### Survey Design:

- **Objective**: Determine the acceptability of the proposed solution compared to existing commuting methods.
- **Participants**: Yonsei University students (sample size: 100).
- **Alternatives**: Village bus, PM, walking, demand-based shuttle bus.
- **Variables**:
    - **Cost**: Specific to alternatives.
    - **In-Vehicle Travel Time (IVT)**: Specific to alternatives.
    - **Out-of-Vehicle Travel Time (OVT)**: Common variable.
    - **Wait Time**: Common variable.
1. **Survey Attribute Levels:**
    
    ![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/db5c33d0-e510-4667-b185-b03bb446fb45/0174906a-e703-4408-b8b8-8276cbcb8969/Untitled.png)
    
2. SAS Result:
    
    ```sass
    %mkturns(3 ** 7)
    
    %mktex(3 ** 7, n=18)
    %mktblock(data=randomized, nblocks=3)
    proc print; run;
    ```
    
    ![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/db5c33d0-e510-4667-b185-b03bb446fb45/8bf33c2b-a3e6-4aac-a40e-75b358d5b753/Untitled.png)
    
3. Survey Construction:
    
    [연세대학교 학생들의 이동성 개선을 위한 설문](https://docs.google.com/forms/d/e/1FAIpQLSetR4TBAHV6a4yHwfQBMrosWr2UColrJjDMXSFV8nNagxh5MA/viewform)
    

### Survey Result Analysis: Part 1. Background

Respondents choose the alternative that maximizes utility. Therefore, to analyze respondents' choices, it is necessary to understand how the utility of each alternative is calculated.

The utility of each alternative is calculated by the utility function.
The utility function ($U_{in} = V_{in} +\epsilon_{in}$) consists of deterministic utility ($V_{in} = \sum\beta_{ik}x_{ink}$) and stochastic utility ($\epsilon_{in}$), with the attributes of fare, in-vehicle travel time, out-of-vehicle travel time, and waiting time set as observable attributes of deterministic utility ($x_{ink}$). The stochastic utility reflects the unobservable or difficult-to-observe utility as a random variable, so it cannot be obtained.

![ref. CRP3770](https://prod-files-secure.s3.us-west-2.amazonaws.com/db5c33d0-e510-4667-b185-b03bb446fb45/74240ecb-f528-4469-b5a3-1ef0430f7e2e/Untitled.png)

ref. CRP3770

The goal is to estimate the coefficients ($\beta_{ik}$) of each attribute included in the deterministic utility to understand the decision-making process influenced by certain attributes in a given situation.

Deterministic utility can be modeled using respondents' choices and the level values of each attribute, and the choice probability of each alternative can be obtained using the logit model as follows: $P_{in} = prob(\epsilon_{jn}-\epsilon_{in} \le V_{in} - V_{jn})$

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/db5c33d0-e510-4667-b185-b03bb446fb45/437a18e0-2468-4876-a292-d91d7f087c88/Untitled.png)

### Survey Result Analysis: Part 2. data

1. Raw data → wide form data
    
    code: [github](https://github.com/jineoni/CRP3770/blob/main/data_processing.ipynb)
    
    > 💡 Error Discovered
    > 
    > 1. No attribute level changes for village bus fare.
    >     
    >     Alternative-specific variable: Fare impacts the utility of each alternative differently, so the fare attribute coefficients for each alternative are estimated individually.
    >     Village bus with no level changes cannot estimate coefficients without slopes.
    >     
    >     > To address this, only PM fare and shuttle bus fare were treated as alternative-specific variables, and village bus fare was included in the alternative-specific intercept.
    >     > 
    > 2. No attribute level changes for waiting time.
    >     
    >     Common variable: Waiting time impacts the utility of each alternative equally, so one coefficient is estimated considering the waiting time attribute for all alternatives.
    >     No level changes for waiting time across all alternatives prevent slope estimation and coefficient calculation.
    >     
    >     > Thus, after trying both models below, the model with the smaller AIC value was selected.
    >     > 
    >     > 1. Include waiting time attribute in the alternative-specific intercept.
    >     > 2. Exclude waiting time attribute from the model.
    > 3. High correlation expected between PM fare and in-vehicle travel time.
    >     
    >     Because, PM fare is determined as “base fare 600 KRW + in-vehicle travel time x 150 KRW.”
    >     
    >     > Hence, PM fare was adjusted to KRW per minute to remove multicollinearity.
    >     > 
    > 4. The interval width of in-vehicle travel time for shuttle buses is constant at all levels.
    >     
    >     The uncertainty of travel time for demand-responsive shuttle buses was included in the model as intervals. However, issues arose because the interval width was set identically at all levels.
    >     
    >     > High correlation between minimum and maximum values was expected, so the minimum value was used as a common variable for in-vehicle travel time, and the maximum value was processed as 5/5, 5/10, and 5/15 to be used as alternative-specific variables.
    >     > 
2. Wide form data → long form data
    - First model
        
        code: [github](https://github.com/jineoni/CRP3770/blob/main/data2.R)
        
    - Second model
        
        code: [github](https://github.com/jineoni/CRP3770/blob/main/data3.R)
        
3. Modeling
    - First model
        
        code: [github](https://github.com/jineoni/CRP3770/blob/main/logit2.R)
        
    - Second model
        
        code: [github](https://github.com/jineoni/CRP3770/blob/main/logit3.R)
        

### Survey Result Analysis: Part 3. analysis

Due to the aforementioned survey errors, meaningful results like willingness to pay could not be derived. However, based on the model estimation results, statistically significant variables and their coefficients were interpreted.

- **Access (Walking time before boarding + Walking time after alighting)**:
    - Estimated coefficient: -0.16557145
    - Longer walking time before boarding + after alighting tends to decrease the utility of the mode.
- **DRT_cost (Demand-Responsive Shuttle Bus fare)**:
    - Estimated coefficient: -0.00138137
    - Increase in Demand-Responsive Shuttle Bus fare tends to decrease its utility.
- **Gender: Walk (Gender: Walking)**:
    - Estimated coefficient: -1.05616893
    - 0: Male, 1: Female
    - Females tend to have lower utility for walking compared to males.
- **Age: Walk (Age: Walking)**:
    - Estimated coefficient: 0.21175833
    - Older age tends to increase the utility for walking (?)
- **Undergrad: PM (Undergraduate/Graduate: PM)**:
    - Estimated coefficient: 1.40336374
    - 0: Graduate student, 1: Undergraduate student
    - Undergraduates tend to have higher utility for PM compared to graduate students.
- **R_type: Walk (Residence type: Walking)**:
    - Estimated coefficient: 0.89941893
    - 0: Lives within specified spatial range (Sinchon and Yeonhui-dong), 1: Lives outside the specified spatial range
    - Students living outside the specified spatial range tend to have higher utility for walking compared to those living within the specified spatial range (?)
- **PM_exp: PM (PM experience: PM)**:
    - Estimated coefficient: 0.83777644
    - 0: No, 1: Yes
    - Students with PM experience tend to have higher utility for PM compared to those without experience.
- **IVT_Bus (In-Vehicle Travel Time for Village Bus)**:
    - Estimated coefficient: -0.13741526
    - Increase in in-vehicle travel time for village bus tends to decrease its utility.
- **IVT_Walk (Walking Travel Time)**:
    - Estimated coefficient: -0.16535330
    - Increase in walking travel time tends to decrease its utility.
