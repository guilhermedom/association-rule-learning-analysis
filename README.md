# Association Rule Learning Analysis

Web app for mining and visually analyzing association rules.

---

### Usage

App currently deployed and accessible at: https://domdatascience.shinyapps.io/association-rule-learning-analysis/

### App Features
* Select any file having lists of purchased items per buyer and automatically mine association rules;
* The app user can set 3 different variables considering the association rules he wants to mine. Only those rules that follow the setted patterns will be learned and visualized:
    1. Minimum support for rules: visualize only the rules which apply to at least this percentage of the data;
    2. Minimum confidence for rules: confidence tells us the probability that an item present in the antecedent of the rule will also be present in the consequent of the rule. Visualize only the rules that have at least this probability;
    3. Minimum length for rules: the minimum number of items that need to occur in a rule for it to be visualized.
* A table of learned rules is at the bottom left corner of the interface where the user can also see the support, confidence and other measures for the rules;
* A directed graph shows the items and the relationship levels amongst them;
* A 2D and a 3D matrix are shown having the lift levels between antecedents (LHS) and consequents (RHS) of the visualized rules;
* Finally, there is group plot connecting itemsets and showing the lift, support and rule count for the connections.

### User Interface Sample

![ui_association-rule-learning-analysis](https://user-images.githubusercontent.com/33037020/184272509-094c08d8-21ae-4882-bd0c-d0251e1ea8e2.png)

*[Shiny] is a framework that allows users to develop web apps using R and embedded web languages, such as CSS and HTML. Shiny apps focus on objectiveness and simplicity: only one or two R scripts have all the code for the app.*

*This app development started with knowledge and tools discussed during the course "Data Science Bootcamp" by Fernando Amaral. The app has been upgraded and personalized, adding new functionalities.*

[//]: #

[Shiny]: <https://www.shinyapps.io>
