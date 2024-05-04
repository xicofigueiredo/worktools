# db/seeds.rb

# Define the subjects for each category along with exam dates
# db/seeds.rb
ActiveRecord::Base.transaction do
  # Other seeding logic here, ensuring uniqueness where necessary

#   math_a_level = Subject.create!(
#     name: "Mathematics A Level",
#     category: :al,
#     )

#   math_a_level.topics.create!(name: "Introduction to the Course", time: 1)
#   math_a_level.topics.create!(name: "Pre-course", time: 1)
#   math_a_level.topics.create!(name: "Topic 1.1 Introduction to Methods of proof", time: 4, unit: "Unit 1: Proof")
#   math_a_level.topics.create!(name: "Topic 1.2 - Proof by Contradiction", time: 3, unit: "Unit 1: Proof")
#   math_a_level.topics.create!(name: "Topic 2.1 Algebraic Expressions, Indices and Surds", time: 4, unit: "Unit 2: Algebra and Functions")
#   math_a_level.topics.create!(name: "Topic 2.2 Quadratics", time: 5, unit: "Unit 2: Algebra and Functions")
#   math_a_level.topics.create!(name: "Topic 2.3 -  Simultaneous Equations", time: 4, unit: "Unit 2: Algebra and Functions")
#   math_a_level.topics.create!(name: "Topic 2.4 - Inequalities", time: 6, unit: "Unit 2: Algebra and Functions")
#   math_a_level.topics.create!(name: "Topic 2.5 - Polynomial and Reciprocal Functions", time: 5, unit: "Unit 2: Algebra and Functions")
#   math_a_level.topics.create!(name: "Topic 2.6 - Transformations and Symmetries", time: 6, unit: "Unit 2: Algebra and Functions")
#   math_a_level.topics.create!(name: "Topic 2.7 - Algebraic Division", time: 4, unit: "Unit 2: Algebra and Functions")
#   math_a_level.topics.create!(name: "End of Unit Assessments", time: 3, unit: "Unit 2: Algebra and Functions", has_grade: true)
#   math_a_level.topics.create!(name: "Topic 2.8 - Algebraic Fraction Manipulation", time: 2, unit: "Unit 2: Algebra and Functions")
#   math_a_level.topics.create!(name: "Topic 2.9 - Partial Fractions", time: 4, unit: "Unit 2: Algebra and Functions")
#   math_a_level.topics.create!(name: "Topic 2.10 - Composite and Inverse Functions", time: 4, unit: "Unit 2: Algebra and Functions")
#   math_a_level.topics.create!(name: "Topic 2.11 - Modulus Function", time: 5, unit: "Unit 2: Algebra and Functions")
#   math_a_level.topics.create!(name: "Topic 2.12 - Composite Transformations", time: 3, unit: "Unit 2: Algebra and Functions")
#   math_a_level.topics.create!(name: "End of Unit Assessments", time: 3, unit: "Unit 2: Algebra and Functions", has_grade: true)
#   math_a_level.topics.create!(name: "Topic 3.1 - Coordinate Geometry of Straigh Lines", time: 6, unit: "Unit 3: Coordinate Geometry")
#   math_a_level.topics.create!(name: "Topic 3.2 - Coordinate Geometry of Circles", time: 8, unit: "Unit 3: Coordinate Geometry")
#   math_a_level.topics.create!(name: "Topic 3.3 - Parametric Equations", time: 3, unit: "Unit 3: Coordinate Geometry")
#   math_a_level.topics.create!(name: "End of Unit Assessments", time: 1, unit: "Unit 3: Coordinate Geometry", has_grade: true)
#   math_a_level.topics.create!(name: "Topic 4.1. Arithmetic Sequences and Series", time: 2, unit: "Unit 4: Sequences, Series and Binomial Expansion")
#   math_a_level.topics.create!(name: "Topic 4.2.  Geometric Sequences and Series", time: 3, unit: "Unit 4: Sequences, Series and Binomial Expansion")
#   math_a_level.topics.create!(name: "Topic 4.3 - General Sequences, Series and Notation", time: 5, unit: "Unit 4: Sequences, Series and Binomial Expansion")
#   math_a_level.topics.create!(name: "Topic 4.4 - Binomial Expansion for Positive Integer Exponents", time: 7, unit: "Unit 4: Sequences, Series and Binomial Expansion")
#   math_a_level.topics.create!(name: "End of Unit Assessments", time: 3, unit: "Unit 4: Sequences, Series and Binomial Expansion", has_grade: true)
#   math_a_level.topics.create!(name: "Topic 4.5 - Binomial Expansion for Rational Powers", time: 7, unit: "Unit 4: Sequences, Series and Binomial Expansion")
#   math_a_level.topics.create!(name: "End of Unit Assessments", time: 3, unit: "Unit 4: Sequences, Series and Binomial Expansion")
#   math_a_level.topics.create!(name: "Topic 5.1. Trigonometry in Triangles", time: 6, unit: "Unit 5: Trigonomentry and Trigonometric Functions", has_grade: true)
#   math_a_level.topics.create!(name: "Topic 5.2. Trigonometry in Circles", time: 5, unit: "Unit 5: Trigonomentry and Trigonometric Functions")
#   math_a_level.topics.create!(name: "Topic 5.3 - Trigonometric Functions", time: 2, unit: "Unit 5: Trigonomentry and Trigonometric Functions")
#   math_a_level.topics.create!(name: "Topic 5.4 - Trigonometric Identities", time: 5, unit: "Unit 5: Trigonomentry and Trigonometric Functions")
#   math_a_level.topics.create!(name: "Topic 5.5 - Trigonometric Equations", time: 5, unit: "Unit 5: Trigonomentry and Trigonometric Functions")
#   math_a_level.topics.create!(name: "End of Unit Assessments", time: 1, unit: "Unit 5: Trigonomentry and Trigonometric Functions", has_grade: true)
#   math_a_level.topics.create!(name: "Topic 5.6 - Reciprocal Trigonometric Functions and Identities", time: 2, unit: "Unit 5: Trigonomentry and Trigonometric Functions")
#   math_a_level.topics.create!(name: "Topic 5.7 - Inverse Trigonometric Functions", time: 3, unit: "Unit 5: Trigonomentry and Trigonometric Functions")
#   math_a_level.topics.create!(name: "Topic 5.8 - Compound, Double and Half-Angle Formulae", time: 6, unit: "Unit 5: Trigonomentry and Trigonometric Functions")
#   math_a_level.topics.create!(name: "Topic 5.9 - Harmonic Forms", time: 3, unit: "Unit 5: Trigonomentry and Trigonometric Functions")
#   math_a_level.topics.create!(name: "End of Unit Assessments", time: 2, unit: "Unit 5: Trigonomentry and Trigonometric Functions", has_grade: true)
#   math_a_level.topics.create!(name: "Topic 6.1 - Exponential and Logarithmic Functions", time: 2, unit: "Unit 6: Exponentials and Logarithms")
#   math_a_level.topics.create!(name: "Topic 6.2 - Manipulating Exponential and Logarithmic Expressions", time: 6, unit: "Unit 6: Exponentials and Logarithms")
#   math_a_level.topics.create!(name: "End of Unit Assessments", time: 3, unit: "Unit 6: Exponentials and Logarithms", has_grade: true)
#   math_a_level.topics.create!(name: "Topic 6.3 - Natural Exponential and Logarithmic Functions", time: 2, unit: "Unit 6: Exponentials and Logarithms")
#   math_a_level.topics.create!(name: "Topic 6.4 - Modelling with Exponential and Logarithmic Functions", time: 8, unit: "Unit 6: Exponentials and Logarithms")
#   math_a_level.topics.create!(name: "End of Unit Assessments", time: 3, unit: "Unit 6: Exponentials and Logarithms", has_grade: true)
#   math_a_level.topics.create!(name: "Topic 7.1 - Introduction to Differentiation: Powers", time: 11, unit: "Unit 7: Differentiation")
#   math_a_level.topics.create!(name: "Topic 7.2 - Stationary Points and Function Behaviour", time: 4, unit: "Unit 7: Differentiation")
#   math_a_level.topics.create!(name: "End of Unit Assessments", time: 1, unit: "Unit 7: Differentiation", has_grade: true)
#   math_a_level.topics.create!(name: "Topic 7.3 - Differentiating Exponentials, Logarithms and Trigonometric Functions", time: 5, unit: "Unit 7: Differentiation")
#   math_a_level.topics.create!(name: "Topic 7.4 - Differentiation Techniques: Product Rule, Quotient Rule and Chain Rule", time: 7, unit: "Unit 7: Differentiation")
#   math_a_level.topics.create!(name: "Topic 7.5 - Differentiating Implicit and Parametric Functions", time: 5, unit: "Unit 7: Differentiation")
#   math_a_level.topics.create!(name: "Topic 7.6 - Connected Rates of Change", time: 3, unit: "Unit 7: Differentiation")
#   math_a_level.topics.create!(name: "End of Unit Assessments", time: 1, unit: "Unit 7: Differentiation", has_grade: true)
#   math_a_level.topics.create!(name: "Topic 8.1 - Indefinite Integration", time: 6, unit: "Unit 8: Integration")
#   math_a_level.topics.create!(name: "Topic 8.2 - Definite Integration and Area under a Curve", time: 5, unit: "Unit 8: Integration")
#   math_a_level.topics.create!(name: "Topic 8.3 - Numerical Integration using the Trapezium Rule", time: 2, unit: "Unit 8: Integration")
#   math_a_level.topics.create!(name: "End of Unit Assessments", time: 2, unit: "Unit 8: Integration", has_grade: true)
#   math_a_level.topics.create!(name: "Topic 8.4 - Integrating Standard Functions", time: 4, unit: "Unit 8: Integration")
#   math_a_level.topics.create!(name: "Topic 8.5 - Integration by Recognition of Known Derivatives and using Trigonometric Identities", time: 5, unit: "Unit 8: Integration")
#   math_a_level.topics.create!(name: "Topic 8.6 - Volumes of Revolution", time: 5, unit: "Unit 8: Integration")
#   math_a_level.topics.create!(name: "Topic 8.7 - Integration Techniques: Integration by Substitution and Integration by Parts", time: 7, unit: "Unit 8: Integration")
#   math_a_level.topics.create!(name: "Topic 8.8 - Integration of Rational Functions using Partial Fractions", time: 3, unit: "Unit 8: Integration")
#   math_a_level.topics.create!(name: "Topic 8.9 - Differential Equations", time: 2, unit: "Unit 8: Integration")
#   math_a_level.topics.create!(name: "Topic 8.10 - Modelling with Differential Equations", time: 2, unit: "Unit 8: Integration")
#   math_a_level.topics.create!(name: "End of Unit Assessments", time: 3, unit: "Unit 8: Integration", has_grade: true)
#   math_a_level.topics.create!(name: "Topic 9.1 - Locating Roots", time: 1, unit: "Unit 9: Numerical Methods")
#   math_a_level.topics.create!(name: "Topic 9.2 - Iterative Methods for Solving Equations", time: 4, unit: "Unit 9: Numerical Methods")
#   math_a_level.topics.create!(name: "End of Unit Assessments", time: 1, unit: "Unit 9: Numerical Methods", has_grade: true)
#   math_a_level.topics.create!(name: "Topic 10.1 - Vector Representations and Operations", time: 5, unit: "Unit 10: Vectors")
#   math_a_level.topics.create!(name: "Topic 10.2 - Position Vectors and Geometrical Problems", time: 3, unit: "Unit 10: Vectors")
#   math_a_level.topics.create!(name: "Topic 10.3 - Vector Equation of the Line", time: 5, unit: "Unit 10: Vectors")
#   math_a_level.topics.create!(name: "Topic 10.4 - Scalar Product", time: 5, unit: "Unit 10: Vectors")
#   math_a_level.topics.create!(name: "End of Unit Assessments", time: 3, unit: "Unit 10: Vectors", has_grade: true)
#   math_a_level.topics.create!(name: "Pure Mathematics MOCK - Paper 1,2,3,4", time: 7, milestone: true, has_grade: true, Mock50: true)
#   math_a_level.topics.create!(name: "Topic 11.1 - Measures of Location and Variation", time: 5, unit: "Unit 11: Representing and Summarising Data")
#   math_a_level.topics.create!(name: "Topic 11.2 - Representing and Comparing Data using Diagrams", time: 8, unit: "Unit 11: Representing and Summarising Data")
#   math_a_level.topics.create!(name: "End of Unit Assessments", time: 1, unit: "Unit 11: Statistics", has_grade: true)
#   math_a_level.topics.create!(name: "Topic 12.1 - Events, Set Notation and Probability Calculations", time: 7, unit: "Unit 12: Probability")
#   math_a_level.topics.create!(name: "Topic 12.2 - Conditional Probability", time: 3, unit: "Unit 12: Probability")
#   math_a_level.topics.create!(name: "End of Unit Assessments", time: 1, unit: "Unit 12: Probability")
#   math_a_level.topics.create!(name: "Topic 13.1 - Scatter Diagrams and Least Squares Linear Regression", time: 9, unit: "Unit 13:  Correlation and Regression")
#   math_a_level.topics.create!(name: "Topic 13.2 - Product Moment Correlation Coeficient (PMCC)", time: 7, unit: "Unit 13:  Correlation and Regression")
#   math_a_level.topics.create!(name: "End of Unit Assessments", time: 1, unit: "Unit 13:  Correlation and Regression", has_grade: true)
#   math_a_level.topics.create!(name: "Topic 14.1. Discrete Random Variables and Distributions", time: 13, unit: "Unit 14: Random Variables and Distributions")
#   math_a_level.topics.create!(name: "Topic 14.2. Continuous Random Variables and Normal Distribution", time: 8, unit: "Unit 14: Random Variables and Distributions")
#   math_a_level.topics.create!(name: "End of Unit Assessments", time: 1, unit: "Unit 14: Random Variables and Distributions", has_grade: true)
#   math_a_level.topics.create!(name: "Warm up mock", time: 3, milestone: true, has_grade: true)
#   math_a_level.topics.create!(name: "Statistics MOCK", time: 2, milestone: true, has_grade: true)
#   math_a_level.topics.create!(name: "Topic 16.1 - Quantities and Units in Mechanics Models", time: 2, unit: "Unit 16: Mathematical Models in Mechanics")
#   math_a_level.topics.create!(name: "Topic 16.2 - Representing Physical Quantities in Mechanics Models", time: 13, unit: "Unit 16: Mathematical Models in Mechanics")
#   math_a_level.topics.create!(name: "MA: End of Unit Assessment 16", time: 1, unit: "Unit 16: Mathematical Models in Mechanics", has_grade: true)
#   math_a_level.topics.create!(name: "Topic 17.1 - Constant Acceleration Formulae", time: 4, unit: "Unit 17: Kinematics of Particles Moving in a Straight Line")
#   math_a_level.topics.create!(name: "Topic 17.2 - Representing and Interpreting Physical Quantities as Graphs", time: 6, unit: "Unit 17: Kinematics of Particles Moving in a Straight Line")
#   math_a_level.topics.create!(name: "Topic 17.3 - Vertical Motion Under Gravity", time: 2, unit: "Unit 17: Kinematics of Particles Moving in a Straight Line")
#   math_a_level.topics.create!(name: "MA: End of unit assessment 17", time: 1, unit: "Unit 17: Kinematics of Particles Moving in a Straight Line", has_grade: true)
#   math_a_level.topics.create!(name: "Topic 18.1 - Representing and Calculating Resultant Forces", time: 3, unit: "Unit 18: Dynamics of Particles Moving in a Straight Line")
#   math_a_level.topics.create!(name: "Topic 18.2 - Newtons Second Law", time: 4, unit: "Unit 18: Dynamics of Particles Moving in a Straight Line")
#   math_a_level.topics.create!(name: "Topic 18.3 - Frictional Forces", time: 4, unit: "Unit 18: Dynamics of Particles Moving in a Straight Line")
#   math_a_level.topics.create!(name: "Topic 18.4 - Connected Particles and Smooth Pulleys", time: 4, unit: "Unit 18: Dynamics of Particles Moving in a Straight Line")
#   math_a_level.topics.create!(name: "Topic 18.5 - Momentum, Impulse and Collisions in 1D", time: 8, unit: "Unit 18: Dynamics of Particles Moving in a Straight Line")
#   math_a_level.topics.create!(name: "End of Unit Assement 18", time: 1, unit: "Unit 18: Dynamics of Particles Moving in a Straight Line", has_grade: true)
#   math_a_level.topics.create!(name: "Topic 19.1 - Static Equilibrium", time: 4, unit: "Unit 19: Statics")
#   math_a_level.topics.create!(name: "Topic 20.1 - Moment of a Force and Rotational Equilibrium", time: 7, unit: "Unit 20: Rotational Effects of Forces")
#   math_a_level.topics.create!(name: "End of Unit Assessment 20", time: 1, unit: "Unit 20: Rotational Effects of Forces", has_grade: true)
#   math_a_level.topics.create!(name: "Course Revision Assessment & Exam Preparation", time: 5, milestone: true, has_grade: true)
#   math_a_level.topics.create!(name: "Warm up mock", time: 3, milestone: true, has_grade: true, Mock100: true)
#   math_a_level.topics.create!(name: "Mechanics MOCK", time: 1, milestone: true, has_grade: true)


#   chemistry_a_level = Subject.create!(
#   name: "Chemistry A Level",
#   category: :al,
#   )

# chemistry_a_level.topics.create!(name: "Topic 1: Fundamental Skills", time: 4, unit: "Unit 0: Introduction to A-Level Chemistry")
# chemistry_a_level.topics.create!(name: "Topic 2: Bridging the Gap", time: 4, unit: "Unit 0: Introduction to A-Level Chemistry")
# chemistry_a_level.topics.create!(name: "Topic 1: Moles and Equations", time: 10, unit: "Unit 1: Structure and Bonding")
# chemistry_a_level.topics.create!(name: "Topic 2: Atomic Structure", time: 5, unit: "Unit 1: Structure and Bonding")
# chemistry_a_level.topics.create!(name: "Topic 3: Electronic Structure", time: 12, unit: "Unit 1: Structure and Bonding")
# chemistry_a_level.topics.create!(name: "Topic 4: Periodic Table", time: 7, unit: "Unit 1: Structure and Bonding")
# chemistry_a_level.topics.create!(name: "Topic 5: States of Matter", time: 3, unit: "Unit 1: Structure and Bonding")
# chemistry_a_level.topics.create!(name: "Topic 6: Chemical Bonding", time: 15, unit: "Unit 1: Structure and Bonding")
# chemistry_a_level.topics.create!(name: "Topic 1: Introductory Organic Chemistry", time: 15, unit: "Unit 2: Introduction to Organic Chemistry")
# chemistry_a_level.topics.create!(name: "Topic 2: Alkanes", time: 10, unit: "Unit 2: Introduction to Organic Chemistry")
# chemistry_a_level.topics.create!(name: "Topic 3: Alkenes", time: 10, unit: "Unit 2: Introduction to Organic Chemistry")
# chemistry_a_level.topics.create!(name: "Warm-up Mock I", time: 2, milestone: true, has_grade: true)
# chemistry_a_level.topics.create!(name: "Topic 1: Intermolecular Forces", time: 15, unit: "Unit 3: Energetics and Group Chemistry")
# chemistry_a_level.topics.create!(name: "Topic 2: Energetics", time: 15, unit: "Unit 3: Energetics and Group Chemistry")
# chemistry_a_level.topics.create!(name: "Topic 3: Introduction to Kinetics and Equilibria", time: 15, unit: "Unit 3: Energetics and Group Chemistry")
# chemistry_a_level.topics.create!(name: "Topic 4: Redox Chemistry", time: 5, unit: "Unit 3: Energetics and Group Chemistry")
# chemistry_a_level.topics.create!(name: "Topic 5: Group Chemistry", time: 12, unit: "Unit 3: Energetics and Group Chemistry")
# chemistry_a_level.topics.create!(name: "Topic 1: Halogenoalkanes", time: 7, unit: "Unit 4: More Organic Chemistry")
# chemistry_a_level.topics.create!(name: "Topic 2: Alcohols", time: 7, unit: "Unit 4: More Organic Chemistry")
# chemistry_a_level.topics.create!(name: "Topic 3: Mass Spectra and IR", time: 7, unit: "Unit 4: More Organic Chemistry")
# chemistry_a_level.topics.create!(name: "Warm-up Mock II", time: 2, milestone: true, has_grade: true)
# chemistry_a_level.topics.create!(name: "Topic 1: Review of practical knowledge and understanding", time: 3, unit: "Unit 5: Practical Skills")
# chemistry_a_level.topics.create!(name: "Topic 2: Colours", time: 3, unit: "Unit 5: Practical Skills")
# chemistry_a_level.topics.create!(name: "Mock 50%", time: 3, milestone: true, has_grade: true, Mock50: true)
# chemistry_a_level.topics.create!(name: "Topic 1: Kinetics", time: 12, unit: "Unit 6: Rates and Equilibria")
# chemistry_a_level.topics.create!(name: "Topic 2: Entropy and Energetics", time: 12, unit: "Unit 6: Rates and Equilibria")
# chemistry_a_level.topics.create!(name: "Topic 3: Chemical Equilibria", time: 12, unit: "Unit 6: Rates and Equilibria")
# chemistry_a_level.topics.create!(name: "Topic 4: Acid-base Equilibria", time: 12, unit: "Unit 6: Rates and Equilibria")
# chemistry_a_level.topics.create!(name: "Topic 1: Chirality", time: 7, unit: "Unit 7: Further Organic Chemistry")
# chemistry_a_level.topics.create!(name: "Topic 2: Carbonyl Group", time: 12, unit: "Unit 7: Further Organic Chemistry")
# chemistry_a_level.topics.create!(name: "Topic 3: Spectroscopy and Chromatography", time: 7, unit: "Unit 7: Further Organic Chemistry")
# chemistry_a_level.topics.create!(name: "Warm-up Mock IV", time: 2, milestone: true, has_grade: true)
# chemistry_a_level.topics.create!(name: "Topic 1: Redox Equilibria", time: 7, unit: "Unit 8: Transition Metals")
# chemistry_a_level.topics.create!(name: "Topic 2: Transition Metals", time: 14, unit: "Unit 8: Transition Metals")
# chemistry_a_level.topics.create!(name: "Topic 1: Arenes", time: 7, unit: "Unit 9: Organic Nitrogen Chemistry")
# chemistry_a_level.topics.create!(name: "Topic 2: Organic Nitrogen Compounds", time: 9, unit: "Unit 9: Organic Nitrogen Chemistry")
# chemistry_a_level.topics.create!(name: "Topic 3: Organic Synthesis", time: 2, unit: "Unit 9: Organic Nitrogen Chemistry")
# chemistry_a_level.topics.create!(name: "Warm-up Mock V", time: 2, milestone: true, has_grade: true)
# chemistry_a_level.topics.create!(name: "Topic 1: Lab Techniques", time: 8, unit: "Unit 10: Exam Preparation")
# chemistry_a_level.topics.create!(name: "Topic 2: Chemical Analysis", time: 8, unit: "Unit 10: Exam Preparation")
# chemistry_a_level.topics.create!(name: "Mock 100%", time: 3, milestone: true, has_grade: true, Mock100: true)

# chemistry_as_level1 = Subject.create!(
#   name: "Chemistry AS Level 1",
#   category: :as,
#   )

# chemistry_as_level1.topics.create!(name: "Topic 1: Fundamental Skills", time: 4, unit: "Unit 0: Introduction to A-Level Chemistry")
# chemistry_as_level1.topics.create!(name: "Topic 2: Bridging the Gap", time: 4, unit: "Unit 0: Introduction to A-Level Chemistry")
# chemistry_as_level1.topics.create!(name: "Topic 1: Moles and Equations", time: 10, unit: "Unit 1: Structure and Bonding")
# chemistry_as_level1.topics.create!(name: "Topic 2: Atomic Structure", time: 5, unit: "Unit 1: Structure and Bonding")
# chemistry_as_level1.topics.create!(name: "Topic 3: Electronic Structure", time: 12, unit: "Unit 1: Structure and Bonding")
# chemistry_as_level1.topics.create!(name: "Topic 4: Periodic Table", time: 7, unit: "Unit 1: Structure and Bonding")
# chemistry_as_level1.topics.create!(name: "Topic 5: States of Matter", time: 3, unit: "Unit 1: Structure and Bonding")
# chemistry_as_level1.topics.create!(name: "Topic 6: Chemical Bonding", time: 15, unit: "Unit 1: Structure and Bonding")
# chemistry_as_level1.topics.create!(name: "Topic 1: Introductory Organic Chemistry", time: 15, unit: "Unit 2: Introduction to Organic Chemistry")
# chemistry_as_level1.topics.create!(name: "Topic 2: Alkanes", time: 10, unit: "Unit 2: Introduction to Organic Chemistry")
# chemistry_as_level1.topics.create!(name: "Topic 3: Alkenes", time: 10, unit: "Unit 2: Introduction to Organic Chemistry")
# chemistry_as_level1.topics.create!(name: "Warm-up Mock I", time: 2, milestone: true, has_grade: true)
# chemistry_as_level1.topics.create!(name: "Topic 1: Intermolecular Forces", time: 15, unit: "Unit 3: Energetics and Group Chemistry")
# chemistry_as_level1.topics.create!(name: "Topic 2: Energetics", time: 15, unit: "Unit 3: Energetics and Group Chemistry")
# chemistry_as_level1.topics.create!(name: "Topic 3: Introduction to Kinetics and Equilibria", time: 15, unit: "Unit 3: Energetics and Group Chemistry")
# chemistry_as_level1.topics.create!(name: "Topic 4: Redox Chemistry", time: 5, unit: "Unit 3: Energetics and Group Chemistry")
# chemistry_as_level1.topics.create!(name: "Topic 5: Group Chemistry", time: 12, unit: "Unit 3: Energetics and Group Chemistry")
# chemistry_as_level1.topics.create!(name: "Topic 1: Halogenoalkanes", time: 7, unit: "Unit 4: More Organic Chemistry")
# chemistry_as_level1.topics.create!(name: "Topic 2: Alcohols", time: 7, unit: "Unit 4: More Organic Chemistry")
# chemistry_as_level1.topics.create!(name: "Topic 3: Mass Spectra and IR", time: 7, unit: "Unit 4: More Organic Chemistry")
# chemistry_as_level1.topics.create!(name: "Warm-up Mock II", time: 2, milestone: true, has_grade: true)
# chemistry_as_level1.topics.create!(name: "Topic 1: Review of practical knowledge and understanding", time: 3, unit: "Unit 5: Practical Skills")
# chemistry_as_level1.topics.create!(name: "Topic 2: Colours", time: 3, unit: "Unit 5: Practical Skills")
# chemistry_as_level1.topics.create!(name: "Mock 50%", time: 3, milestone: true, has_grade: true, Mock50: true)


# chemistry_as_level2 = Subject.create!(
#   name: "Chemistry AS Level 2",
#   category: :as,
#   )

# chemistry_as_level2.topics.create!(name: "Topic 1: Kinetics", time: 12, unit: "Unit 6: Rates and Equilibria")
# chemistry_as_level2.topics.create!(name: "Topic 2: Entropy and Energetics", time: 12, unit: "Unit 6: Rates and Equilibria")
# chemistry_as_level2.topics.create!(name: "Topic 3: Chemical Equilibria", time: 12, unit: "Unit 6: Rates and Equilibria")
# chemistry_as_level2.topics.create!(name: "Topic 4: Acid-base Equilibria", time: 12, unit: "Unit 6: Rates and Equilibria")
# chemistry_as_level2.topics.create!(name: "Topic 1: Chirality", time: 7, unit: "Unit 7: Further Organic Chemistry")
# chemistry_as_level2.topics.create!(name: "Topic 2: Carbonyl Group", time: 12, unit: "Unit 7: Further Organic Chemistry")
# chemistry_as_level2.topics.create!(name: "Topic 3: Spectroscopy and Chromatography", time: 7, unit: "Unit 7: Further Organic Chemistry")
# chemistry_as_level2.topics.create!(name: "Warm-up Mock IV", time: 2, milestone: true, has_grade: true)
# chemistry_as_level2.topics.create!(name: "Topic 1: Redox Equilibria", time: 7, unit: "Unit 8: Transition Metals")
# chemistry_as_level2.topics.create!(name: "Topic 2: Transition Metals", time: 14, unit: "Unit 8: Transition Metals")
# chemistry_as_level2.topics.create!(name: "Topic 1: Arenes", time: 7, unit: "Unit 9: Organic Nitrogen Chemistry")
# chemistry_as_level2.topics.create!(name: "Topic 2: Organic Nitrogen Compounds", time: 9, unit: "Unit 9: Organic Nitrogen Chemistry")
# chemistry_as_level2.topics.create!(name: "Topic 3: Organic Synthesis", time: 2, unit: "Unit 9: Organic Nitrogen Chemistry")
# chemistry_as_level2.topics.create!(name: "Warm-up Mock V", time: 2, milestone: true, has_grade: true)
# chemistry_as_level2.topics.create!(name: "Topic 1: Lab Techniques", time: 8, unit: "Unit 10: Exam Preparation")
# chemistry_as_level2.topics.create!(name: "Topic 2: Chemical Analysis", time: 8, unit: "Unit 10: Exam Preparation")
# chemistry_as_level2.topics.create!(name: "Mock 100%", time: 3, milestone: true, has_grade: true, Mock100: true)


# physics_a_level = Subject.create!(
#   name: "Physics A Level",
#   category: :al,
#   )

#   physics_a_level.topics.create!(name: "Practical Skills in Physics: Part 1", time: 4, unit: "Unit 0: Introduction to A-Level Physics")
#   physics_a_level.topics.create!(name: "Unit 1: Topic 1.1: Kinematics in 1 Dimension", time: 8, unit: "Unit 1: Mechanics")
#   physics_a_level.topics.create!(name: "Topic 1.2: Kinematics in 2 Dimensions", time: 11, unit: "Unit 1: Mechanics")
#   physics_a_level.topics.create!(name: "Topic 1.3: Single Body Dynamics", time: 8, unit: "Unit 1: Mechanics")
#   physics_a_level.topics.create!(name: "Topic 1.4: Multiple Body Dynamics", time: 10, unit: "Unit 1: Mechanics")
#   physics_a_level.topics.create!(name: "Topic 1.5: Rotational Effect of a Force", time: 6, unit: "Unit 1: Mechanics")
#   physics_a_level.topics.create!(name: "Topic 1.6: Mechanical Energy and Work", time: 13, unit: "Unit 1: Mechanics")
#   physics_a_level.topics.create!(name: "Unit 2: Topic 2.1: Material vs Object Properties", time: 4, unit: "Unit 2: Materials")
#   physics_a_level.topics.create!(name: "Topic 2.2: Forces in Fluids: Viscous Drag and Upthrust", time: 8, unit: "Unit 2: Materials")
#   physics_a_level.topics.create!(name: "Topic 2.3: Forces and Deformation", time: 6, unit: "Unit 2: Materials")
#   physics_a_level.topics.create!(name: "Topic 2.4: Stress, Strain and the Young Modulus", time: 6, unit: "Unit 2: Materials")
#   physics_a_level.topics.create!(name: "Topic 2.5: Energy Considerations in Deformation", time: 9, unit: "Unit 2: Materials")
#   physics_a_level.topics.create!(name: "Unit 3: Topic 3.1: Wave Types and Properties", time: 8, unit: "Unit 3: Waves")
#   physics_a_level.topics.create!(name: "Topic 3.2: How Waves Interact With Other Waves", time: 14, unit: "Unit 3: Waves")
#   physics_a_level.topics.create!(name: "Topic 3.3: How Waves Interact With Matter", time: 15, unit: "Unit 3: Waves")
#   physics_a_level.topics.create!(name: "Unit 4: Topic 4.1: Wave Particle Duality", time: 6, unit: "Unit 4: Quantum Physics")
#   physics_a_level.topics.create!(name: "Topic 4.2: Energy of a Photon and Photoelectric Effect", time: 6, unit: "Unit 4: Quantum Physics")
#   physics_a_level.topics.create!(name: "Topic 4.3: Atomic Electron Energies and Atomic Spectra", time: 9, unit: "Unit 4: Quantum Physics")
#   physics_a_level.topics.create!(name: "Unit 5: Topic 5.1: Macroscopic Electrical Quantities", time: 8, unit: "Unit 5: Electricity")
#   physics_a_level.topics.create!(name: "Topic 5.2: Microscopic Eelectrical Quantities", time: 8, unit: "Unit 5: Electricity")
#   physics_a_level.topics.create!(name: "Topic 5.3: Circuit Topologies", time: 10, unit: "Unit 5: Electricity")
#   physics_a_level.topics.create!(name: "Topic 5.4: Internal Resistance and EMF", time: 6, unit: "Unit 5: Electricity")
#   physics_a_level.topics.create!(name: "Topic 5.5: Variable Resistances", time: 9, unit: "Unit 5: Electricity")
#   physics_a_level.topics.create!(name: "Unit 6: Topic 6.1: Charge, Electric Field, Electric Force", time: 8, unit: "Unit 6: Fields")
#   physics_a_level.topics.create!(name: "Topic 6.2: Role of Electric Fields in Circuits", time: 6, unit: "Unit 6: Fields")
#   physics_a_level.topics.create!(name: "Topic 6.3: Magnetic Field and Magnetic Force", time: 6, unit: "Unit 6: Fields")
#   physics_a_level.topics.create!(name: "Topic 6.4: Electromagnetic Induction", time: 11, unit: "Unit 6: Fields")
#   physics_a_level.topics.create!(name: "Mock 50% Warm Up", time: 2, milestone: true, has_grade: true)
#   physics_a_level.topics.create!(name: "Mock 50%", time: 3, milestone: true, has_grade: true, Mock50: true)
#   physics_a_level.topics.create!(name: "Practical Skills in Physics: Part 2", time: 4, unit: "Unit 0: Introduction to A-Level Physics")
#   physics_a_level.topics.create!(name: "Unit 7: Topic 7.1: Nuclear Models of the Atom and Where We are Now", time: 4, unit: "Unit 7: Nuclear Physics")
#   physics_a_level.topics.create!(name: "Topic 7.2: Exploring the Structure of Matter", time: 6, unit: "Unit 7: Nuclear Physics")
#   physics_a_level.topics.create!(name: "Topic 7.3: Standard Model: Particle Interactions", time: 11, unit: "Unit 7: Nuclear Physics")
#   physics_a_level.topics.create!(name: "Unit 8: Topic 8.1: Temperature and Internal Energy", time: 6, unit: "Unit 8: Thermal Physics")
#   physics_a_level.topics.create!(name: "Topic 8.2: Heat Transfer", time: 11, unit: "Unit 8: Thermal Physics")
#   physics_a_level.topics.create!(name: "Topic 8.3: Kinetic Theory and Ideal Gases", time: 11, unit: "Unit 8: Thermal Physics")
#   physics_a_level.topics.create!(name: "Unit 9: Topic 9.1: Types of Nuclear Radiation", time: 6, unit: "Unit 9: Nuclear Physics")
#   physics_a_level.topics.create!(name: "Topic 9.2: Radioactive Decay", time: 8, unit: "Unit 9: Nuclear Physics")
#   physics_a_level.topics.create!(name: "Topic 9.3: Nuclear Binding Energy", time: 11, unit: "Unit 9: Nuclear Physics")
#   physics_a_level.topics.create!(name: "Unit 10: Topic 10.1: Newtons Law of Universal Gravitation", time: 8, unit: "Unit 10: Astrophysics")
#   physics_a_level.topics.create!(name: "Topic 10.2: Orbital Motion", time: 11, unit: "Unit 10: Astrophysics")
#   physics_a_level.topics.create!(name: "Unit 11: Topic 11.1: Black Body Radiation", time: 6, unit: "Unit 11: Cosmology")
#   physics_a_level.topics.create!(name: "Topic 11.2: Stellar Classification", time: 8, unit: "Unit 11: Cosmology")
#   physics_a_level.topics.create!(name: "Topic 11.3: Stellar Distances", time: 4, unit: "Unit 11: Cosmology")
#   physics_a_level.topics.create!(name: "Topic 11.4: Age of the Universe", time: 13, unit: "Unit 11: Cosmology")
#   physics_a_level.topics.create!(name: "Unit 12: Topic 12.1: Colision Dynamics", time: 8, unit: "Unit 12: Further Mechanics")
#   physics_a_level.topics.create!(name: "Topic 12.2: Rotational Motion", time: 6, unit: "Unit 12: Further Mechanics")
#   physics_a_level.topics.create!(name: "Topic 12.3: Oscilations", time: 13, unit: "Unit 12: Further Mechanics")
#   physics_a_level.topics.create!(name: "Practical Skills in Physics II", time: 4, unit: "Unit 0: Introduction to A-Level Physics")
#   physics_a_level.topics.create!(name: "Mock 100% Warm Up", time: 2, milestone: true, has_grade: true)
#   physics_a_level.topics.create!(name: "Mock 100%", time: 3, milestone: true, has_grade: true, Mock100: true)

# physics_as_level1 = Subject.create!(
#   name: "Physics AS Level 1",
#   category: :as,
#   )

# physics_as_level1.topics.create!(name: "Practical Skills in Physics: Part 1", time: 4, unit: "Unit 0: Introduction to A-Level Physics")
# physics_as_level1.topics.create!(name: "Unit 1: Topic 1.1: Kinematics in 1 Dimension", time: 8, unit: "Unit 1: Mechanics")
# physics_as_level1.topics.create!(name: "Topic 1.2: Kinematics in 2 Dimensions", time: 11, unit: "Unit 1: Mechanics")
# physics_as_level1.topics.create!(name: "Topic 1.3: Single Body Dynamics", time: 8, unit: "Unit 1: Mechanics")
# physics_as_level1.topics.create!(name: "Topic 1.4: Multiple Body Dynamics", time: 10, unit: "Unit 1: Mechanics")
# physics_as_level1.topics.create!(name: "Topic 1.5: Rotational Effect of a Force", time: 6, unit: "Unit 1: Mechanics")
# physics_as_level1.topics.create!(name: "Topic 1.6: Mechanical Energy and Work", time: 13, unit: "Unit 1: Mechanics")
# physics_as_level1.topics.create!(name: "Unit 2: Topic 2.1: Material vs Object Properties", time: 4, unit: "Unit 2: Materials")
# physics_as_level1.topics.create!(name: "Topic 2.2: Forces in Fluids: Viscous Drag and Upthrust", time: 8, unit: "Unit 2: Materials")
# physics_as_level1.topics.create!(name: "Topic 2.3: Forces and Deformation", time: 6, unit: "Unit 2: Materials")
# physics_as_level1.topics.create!(name: "Topic 2.4: Stress, Strain and the Young Modulus", time: 6, unit: "Unit 2: Materials")
# physics_as_level1.topics.create!(name: "Topic 2.5: Energy Considerations in Deformation", time: 9, unit: "Unit 2: Materials")
# physics_as_level1.topics.create!(name: "Unit 3: Topic 3.1: Wave Types and Properties", time: 8, unit: "Unit 3: Waves")
# physics_as_level1.topics.create!(name: "Topic 3.2: How Waves Interact With Other Waves", time: 14, unit: "Unit 3: Waves")
# physics_as_level1.topics.create!(name: "Topic 3.3: How Waves Interact With Matter", time: 15, unit: "Unit 3: Waves")
# physics_as_level1.topics.create!(name: "Unit 4: Topic 4.1: Wave Particle Duality", time: 6, unit: "Unit 4: Quantum Physics")
# physics_as_level1.topics.create!(name: "Topic 4.2: Energy of a Photon and Photoelectric Effect", time: 6, unit: "Unit 4: Quantum Physics")
# physics_as_level1.topics.create!(name: "Topic 4.3: Atomic Electron Energies and Atomic Spectra", time: 9, unit: "Unit 4: Quantum Physics")
# physics_as_level1.topics.create!(name: "Unit 5: Topic 5.1: Macroscopic Electrical Quantities", time: 8, unit: "Unit 5: Electricity")
# physics_as_level1.topics.create!(name: "Topic 5.2: Microscopic Eelectrical Quantities", time: 8, unit: "Unit 5: Electricity")
# physics_as_level1.topics.create!(name: "Topic 5.3: Circuit Topologies", time: 10, unit: "Unit 5: Electricity")
# physics_as_level1.topics.create!(name: "Topic 5.4: Internal Resistance and EMF", time: 6, unit: "Unit 5: Electricity")
# physics_as_level1.topics.create!(name: "Topic 5.5: Variable Resistances", time: 9, unit: "Unit 5: Electricity")
# physics_as_level1.topics.create!(name: "Unit 6: Topic 6.1: Charge, Electric Field, Electric Force", time: 8, unit: "Unit 6: Fields")
# physics_as_level1.topics.create!(name: "Topic 6.2: Role of Electric Fields in Circuits", time: 6, unit: "Unit 6: Fields")
# physics_as_level1.topics.create!(name: "Topic 6.3: Magnetic Field and Magnetic Force", time: 6, unit: "Unit 6: Fields")
# physics_as_level1.topics.create!(name: "Topic 6.4: Electromagnetic Induction", time: 11, unit: "Unit 6: Fields")
# physics_as_level1.topics.create!(name: "Mock 50% Warm Up", time: 2, milestone: true, has_grade: true)
# physics_as_level1.topics.create!(name: "Mock 50%", time: 3, milestone: true, has_grade: true, Mock50: true)


# physics_as_level2 = Subject.create!(
#   name: "Physics AS Level 2",
#   category: :as,
#   )

# physics_as_level2.topics.create!(name: "Practical Skills in Physics: Part 2", time: 4, unit: "Unit 0: Introduction to A-Level Physics")
# physics_as_level2.topics.create!(name: "Topic 7.1: Nuclear Models of the Atom and Where We are Now", time: 4, unit: "Unit 7: Nuclear Physics")
# physics_as_level2.topics.create!(name: "Topic 7.2: Exploring the Structure of Matter", time: 6, unit: "Unit 7: Nuclear Physics")
# physics_as_level2.topics.create!(name: "Topic 7.3: Standard Model: Particle Interactions", time: 11, unit: "Unit 7: Nuclear Physics")
# physics_as_level2.topics.create!(name: "Topic 8.1: Temperature and Internal Energy", time: 6, unit: "Unit 8: Thermal Physics")
# physics_as_level2.topics.create!(name: "Topic 8.2: Heat Transfer", time: 11, unit: "Unit 8: Thermal Physics")
# physics_as_level2.topics.create!(name: "Topic 8.3: Kinetic Theory and Ideal Gases", time: 11, unit: "Unit 8: Thermal Physics")
# physics_as_level2.topics.create!(name: "Topic 9.1: Types of Nuclear Radiation", time: 6, unit: "Unit 9: Nuclear Physics")
# physics_as_level2.topics.create!(name: "Topic 9.2: Radioactive Decay", time: 8, unit: "Unit 9: Nuclear Physics")
# physics_as_level2.topics.create!(name: "Topic 9.3: Nuclear Binding Energy", time: 11, unit: "Unit 9: Nuclear Physics")
# physics_as_level2.topics.create!(name: "Topic 10.1: Newtons Law of Universal Gravitation", time: 8, unit: "Unit 10: Astrophysics")
# physics_as_level2.topics.create!(name: "Topic 10.2: Orbital Motion", time: 11, unit: "Unit 10: Astrophysics")
# physics_as_level2.topics.create!(name: "Topic 11.1: Black Body Radiation", time: 6, unit: "Unit 11: Cosmology")
# physics_as_level2.topics.create!(name: "Topic 11.2: Stellar Classification", time: 8, unit: "Unit 11: Cosmology")
# physics_as_level2.topics.create!(name: "Topic 11.3: Stellar Distances", time: 4, unit: "Unit 11: Cosmology")
# physics_as_level2.topics.create!(name: "Topic 11.4: Age of the Universe", time: 13, unit: "Unit 11: Cosmology")
# physics_as_level2.topics.create!(name: "Topic 12.1: Colision Dynamics", time: 8, unit: "Unit 12: Further Mechanics")
# physics_as_level2.topics.create!(name: "Topic 12.2: Rotational Motion", time: 6, unit: "Unit 12: Further Mechanics")
# physics_as_level2.topics.create!(name: "Topic 12.3: Oscilations", time: 13, unit: "Unit 12: Further Mechanics")
# physics_as_level2.topics.create!(name: "Practical Skills in Physics II", time: 4, unit: "Unit 0: Introduction to A-Level Physics")
# physics_as_level2.topics.create!(name: "Mock 100% Warm Up", time: 2, milestone: true, has_grade: true)
# physics_as_level2.topics.create!(name: "Mock 100%", time: 3, milestone: true, has_grade: true, Mock100: true)

#   biology_a_level = Subject.create!(
#   name: "Biology A Level",
#   category: :al,
#   )

#   biology_a_level.topics.create!(name: "Unit 1: Molecules, Diet, Transport and Health", time: 5, unit: "Unit 1: Molecules, Diet, Transport and Health")
#   biology_a_level.topics.create!(name: "Topic 1: Molecules, Transport and Health", time: 30, unit: "Unit 1: Molecules, Diet, Transport and Health")
#   biology_a_level.topics.create!(name: "Topic 2: Membranes, Proteins, DNA and Gene Expression", time: 35, unit: "Unit 1: Molecules, Diet, Transport and Health")
#   biology_a_level.topics.create!(name: "Unit 2: Cells, Development, Biodiversity and Conservation", time: 5, unit: "Unit 2: Cells, Development, Biodiversity and Conservation")
#   biology_a_level.topics.create!(name: "Topic 3: Cell Structure, Reproduction and Development", time: 30, unit: "Unit 2: Cells, Development, Biodiversity and Conservation")
#   biology_a_level.topics.create!(name: "Topic 4: Plant Structure and Function, Biodiversity and Conservation", time: 35, unit: "Unit 2: Cells, Development, Biodiversity and Conservation")
#   biology_a_level.topics.create!(name: "Unit 3: Practical Skills in Biology I", time: 5, unit: "Unit 3: Practical Skills in Biology I")
#   biology_a_level.topics.create!(name: "50% Mock Exam Preparation", time: 10, unit: "Unit 3: Practical Skills in Biology I")
#   biology_a_level.topics.create!(name: "50% Mock Exam", time: 2, unit: "Unit 3: Practical Skills in Biology I", milestone: true, has_grade: true, Mock50: true)
#   biology_a_level.topics.create!(name: "Unit 4: Energy, Environment, Microbiology and Immunity", time: 5, unit: "Unit 4: Energy, Environment, Microbiology and Immunity")
#   biology_a_level.topics.create!(name: "Topic 5: Energy Flow, Ecosystems and the Environment", time: 35, unit: "Unit 4: Energy, Environment, Microbiology and Immunity")
#   biology_a_level.topics.create!(name: "Topic 6: Microbiology, Immunity and Forensics", time: 35, unit: "Unit 4: Energy, Environment, Microbiology and Immunity")
#   biology_a_level.topics.create!(name: "Unit 5: Respiration, Internal Environment, Coordination and Gene Technology", time: 5, unit: "Unit 5: Respiration, Internal Environment, Coordination and Gene Technology")
#   biology_a_level.topics.create!(name: "Topic 7: Respiration, Muscles and the Internal Environment", time: 35, unit: "Unit 5: Respiration, Internal Environment, Coordination and Gene Technology")
#   biology_a_level.topics.create!(name: "Topic 8: Coordination, Response and Gene Technology", time: 35, unit: "Unit 5: Respiration, Internal Environment, Coordination and Gene Technology")
#   biology_a_level.topics.create!(name: "Unit 6: Practical Skills in Biology II", time: 5, unit: "Unit 6: Practical Skills in Biology II")
#   biology_a_level.topics.create!(name: "Course Recap and Summaries", time: 5, unit: "Unit 6: Practical Skills in Biology II")
#   biology_a_level.topics.create!(name: "100% Mock Exam Preparation", time: 10, unit: "Unit 6: Practical Skills in Biology II")
#   biology_a_level.topics.create!(name: "100% Mock Exam", time: 2, unit: "Unit 6: Practical Skills in Biology II", milestone: true, has_grade: true, Mock100: true)

# biology_as_level1 = Subject.create!(
#   name: "Biology AS Level 1",
#   category: :as,
#   )

# biology_as_level1.topics.create!(name: "Unit 1: Molecules, Diet, Transport and Health", time: 5, unit: "Unit 1: Molecules, Diet, Transport and Health")
# biology_as_level1.topics.create!(name: "Topic 1: Molecules, Transport and Health", time: 30, unit: "Unit 1: Molecules, Diet, Transport and Health")
# biology_as_level1.topics.create!(name: "Topic 2: Membranes, Proteins, DNA and Gene Expression", time: 35, unit: "Unit 1: Molecules, Diet, Transport and Health")
# biology_as_level1.topics.create!(name: "Unit 2: Cells, Development, Biodiversity and Conservation", time: 5, unit: "Unit 2: Cells, Development, Biodiversity and Conservation")
# biology_as_level1.topics.create!(name: "Topic 3: Cell Structure, Reproduction and Development", time: 30, unit: "Unit 2: Cells, Development, Biodiversity and Conservation")
# biology_as_level1.topics.create!(name: "Topic 4: Plant Structure and Function, Biodiversity and Conservation", time: 35, unit: "Unit 2: Cells, Development, Biodiversity and Conservation")
# biology_as_level1.topics.create!(name: "Unit 3: Practical Skills in Biology I", time: 5, unit: "Unit 3: Practical Skills in Biology I")
# biology_as_level1.topics.create!(name: "50% Mock Exam Preparation", time: 10, unit: "Unit 3: Practical Skills in Biology I")
# biology_as_level1.topics.create!(name: "50% Mock Exam", time: 2, unit: "Unit 3: Practical Skills in Biology I", milestone: true, has_grade: true, Mock50: true)

# biology_as_level2 = Subject.create!(
#   name: "Biology AS Level 2",
#   category: :as,
#   )

# biology_as_level2.topics.create!(name: "Unit 4: Energy, Environment, Microbiology and Immunity", time: 5, unit: "Unit 4: Energy, Environment, Microbiology and Immunity")
# biology_as_level2.topics.create!(name: "Topic 5: Energy Flow, Ecosystems and the Environment", time: 35, unit: "Unit 4: Energy, Environment, Microbiology and Immunity")
# biology_as_level2.topics.create!(name: "Topic 6: Microbiology, Immunity and Forensics", time: 35, unit: "Unit 4: Energy, Environment, Microbiology and Immunity")
# biology_as_level2.topics.create!(name: "Unit 5: Respiration, Internal Environment, Coordination and Gene Technology", time: 5, unit: "Unit 5: Respiration, Internal Environment, Coordination and Gene Technology")
# biology_as_level2.topics.create!(name: "Topic 7: Respiration, Muscles and the Internal Environment", time: 35, unit: "Unit 5: Respiration, Internal Environment, Coordination and Gene Technology")
# biology_as_level2.topics.create!(name: "Topic 8: Coordination, Response and Gene Technology", time: 35, unit: "Unit 5: Respiration, Internal Environment, Coordination and Gene Technology")
# biology_as_level2.topics.create!(name: "Unit 6: Practical Skills in Biology II", time: 5, unit: "Unit 6: Practical Skills in Biology II")
# biology_as_level2.topics.create!(name: "Course Recap and Summaries", time: 5, unit: "Unit 6: Practical Skills in Biology II")
# biology_as_level2.topics.create!(name: "100% Mock Exam Preparation", time: 10, unit: "Unit 6: Practical Skills in Biology II")
# biology_as_level2.topics.create!(name: "100% Mock Exam", time: 2, unit: "Unit 6: Practical Skills in Biology II", milestone: true, has_grade: true, Mock100: true)

# business_a_level = Subject.create!(
#   name: "Business A Level",
#   category: :al,
#   )

#   business_a_level.topics.create!(name: "Unit 1: Marketing and People", time: 5, unit: "Unit 1: Marketing and People")
#   business_a_level.topics.create!(name: "Topic 1.1 Meeting Customer Needs - Part I", time: 7, unit: "Unit 1: Marketing and People")
#   business_a_level.topics.create!(name: "Topic 1.1 Meeting Customer Needs - Part II", time: 4, unit: "Unit 1: Marketing and People")
#   business_a_level.topics.create!(name: "Topic 1.2 The Market - Part I", time: 8, unit: "Unit 1: Marketing and People")
#   business_a_level.topics.create!(name: "Topic 1.2 The Market - Part II", time: 12, unit: "Unit 1: Marketing and People")
#   business_a_level.topics.create!(name: "Topic 1.3 Marketing Mix and Strategy - Part I", time: 11, unit: "Unit 1: Marketing and People")
#   business_a_level.topics.create!(name: "Topic 1.3 Marketing Mix and Strategy - Part II", time: 8, unit: "Unit 1: Marketing and People")
#   business_a_level.topics.create!(name: "Topic 1.4 Managing People - Part I", time: 11, unit: "Unit 1: Marketing and People")
#   business_a_level.topics.create!(name: "Topic 1.4 Managing People - Part II", time: 9, unit: "Unit 1: Marketing and People")
#   business_a_level.topics.create!(name: "Topic 1.5 Entrepreneurs and Leaders - Part I", time: 8, unit: "Unit 1: Marketing and People")
#   business_a_level.topics.create!(name: "Topic 1.5 Entrepreneurs and Leaders - Part II", time: 7, unit: "Unit 1: Marketing and People")
#   business_a_level.topics.create!(name: "Unit 1 Assessment", time: 3, unit: "Unit 1: Marketing and People", has_grade: true)
#   business_a_level.topics.create!(name: "Unit 2: Managing Business Activities", time: 5, unit: "Unit 2: Managing Business Activities")
#   business_a_level.topics.create!(name: "Topic 2.1 Planning a Business and Raising Finance - Part I", time: 9, unit: "Unit 2: Managing Business Activities")
#   business_a_level.topics.create!(name: "Topic 2.1 Planning a Business and Raising Finance - Part II", time: 8, unit: "Unit 2: Managing Business Activities")
#   business_a_level.topics.create!(name: "Topic 2.2 Financial Planning - Part I", time: 8, unit: "Unit 2: Managing Business Activities")
#   business_a_level.topics.create!(name: "Topic 2.2 Financial Planning - Part II", time: 11, unit: "Unit 2: Managing Business Activities")
#   business_a_level.topics.create!(name: "Topic 2.3 Managing Finance - Part I", time: 4, unit: "Unit 2: Managing Business Activities")
#   business_a_level.topics.create!(name: "Topic 2.3 Managing Finance - Part II", time: 7, unit: "Unit 2: Managing Business Activities")
#   business_a_level.topics.create!(name: "Topic 2.4 Resource Management - Part I", time: 8, unit: "Unit 2: Managing Business Activities")
#   business_a_level.topics.create!(name: "Topic 2.4 Resource Management - Part II", time: 7, unit: "Unit 2: Managing Business Activities")
#   business_a_level.topics.create!(name: "Topic 2.5 External Influences - Part I", time: 7, unit: "Unit 2: Managing Business Activities")
#   business_a_level.topics.create!(name: "Topic 2.5 External Influences - Part II", time: 4, unit: "Unit 2: Managing Business Activities")
#   business_a_level.topics.create!(name: "Unit 2 Assessment", time: 2, unit: "Unit 2: Managing Business Activities", has_grade: true)
#   business_a_level.topics.create!(name: "50% Mock Exam", time: 2, unit: "Unit 2: Managing Business Activities", milestone: true, has_grade: true, Mock50: true)
#   business_a_level.topics.create!(name: "Unit 3: Business Decisions and Strategy", time: 5, unit: "Unit 3: Business Decisions and Strategy")
#   business_a_level.topics.create!(name: "Topic 3.1 Business Objectives and Strategy - Part I", time: 7, unit: "Unit 3: Business Decisions and Strategy")
#   business_a_level.topics.create!(name: "Topic 3.1 Business Objectives and Strategy - Part II", time: 8, unit: "Unit 3: Business Decisions and Strategy")
#   business_a_level.topics.create!(name: "Topic 3.2 Business Growth - Part I", time: 6, unit: "Unit 3: Business Decisions and Strategy")
#   business_a_level.topics.create!(name: "Topic 3.2 Business Growth - Part II", time: 7, unit: "Unit 3: Business Decisions and Strategy")
#   business_a_level.topics.create!(name: "Topic 3.3 Decision-Making Techniques - Part I", time: 11, unit: "Unit 3: Business Decisions and Strategy")
#   business_a_level.topics.create!(name: "Topic 3.3 Decision-Making Techniques - Part II", time: 10, unit: "Unit 3: Business Decisions and Strategy")
#   business_a_level.topics.create!(name: "Topic 3.4 Influences on Business Decisions - Part I", time: 5, unit: "Unit 3: Business Decisions and Strategy")
#   business_a_level.topics.create!(name: "Topic 3.4 Influences on Business Decisions - Part II", time: 7, unit: "Unit 3: Business Decisions and Strategy")
#   business_a_level.topics.create!(name: "Topic 3.5 Assessing Competitiveness - Part I", time: 4, unit: "Unit 3: Business Decisions and Strategy")
#   business_a_level.topics.create!(name: "Topic 3.5 Assessing Competitiveness - Part II", time: 6, unit: "Unit 3: Business Decisions and Strategy")
#   business_a_level.topics.create!(name: "Topic 3.6 Managing Change", time: 6, unit: "Unit 3: Business Decisions and Strategy")
#   business_a_level.topics.create!(name: "Unit 3 Assessment", time: 2, unit: "Unit 3: Business Decisions and Strategy", has_grade: true)
#   business_a_level.topics.create!(name: "Unit 4: Global Business", time: 5, unit: "Unit 4: Global Business")
#   business_a_level.topics.create!(name: "Topic 4.1 Globalisation - Part I", time: 8, unit: "Unit 4: Global Business")
#   business_a_level.topics.create!(name: "Topic 4.1 Globalisation - Part II", time: 7, unit: "Unit 4: Global Business")
#   business_a_level.topics.create!(name: "Topic 4.2 Global Markets and Business Expansion - Part I", time: 8, unit: "Unit 4: Global Business")
#   business_a_level.topics.create!(name: "Topic 4.2 Global Markets and Business Expansion - Part II", time: 7, unit: "Unit 4: Global Business")
#   business_a_level.topics.create!(name: "Topic 4.3 Global Marketing - Part I", time: 6, unit: "Unit 4: Global Business")
#   business_a_level.topics.create!(name: "Topic 4.3 Global Marketing - Part II", time: 4, unit: "Unit 4: Global Business")
#   business_a_level.topics.create!(name: "Topic 4.4 Global Industries and Companies - Part I", time: 6, unit: "Unit 4: Global Business")
#   business_a_level.topics.create!(name: "Topic 4.4 Global Industries and Companies - Part II", time: 4, unit: "Unit 4: Global Business")
#   business_a_level.topics.create!(name: "Unit 4 Assessment", time: 2, unit: "Unit 4: Global Business", has_grade: true)
#   business_a_level.topics.create!(name: "100% Mock Exam", time: 2, unit: "Unit 4: Global Business", milestone: true, has_grade: true, Mock100: true)

# business_as_level1 = Subject.create!(
#   name: "Business AS Level 1",
#   category: :as,
#   )

# business_as_level1.topics.create!(name: "Topic 1.1 Meeting Customer Needs - Part I", time: 7, unit: "Unit 1: Marketing and People")
# business_as_level1.topics.create!(name: "Topic 1.1 Meeting Customer Needs - Part II", time: 4, unit: "Unit 1: Marketing and People")
# business_as_level1.topics.create!(name: "Topic 1.2 The Market - Part I", time: 8, unit: "Unit 1: Marketing and People")
# business_as_level1.topics.create!(name: "Topic 1.2 The Market - Part II", time: 12, unit: "Unit 1: Marketing and People")
# business_as_level1.topics.create!(name: "Topic 1.3 Marketing Mix and Strategy - Part I", time: 11, unit: "Unit 1: Marketing and People")
# business_as_level1.topics.create!(name: "Topic 1.3 Marketing Mix and Strategy - Part II", time: 8, unit: "Unit 1: Marketing and People")
# business_as_level1.topics.create!(name: "Topic 1.4 Managing People - Part I", time: 11, unit: "Unit 1: Marketing and People")
# business_as_level1.topics.create!(name: "Topic 1.4 Managing People - Part II", time: 9, unit: "Unit 1: Marketing and People")
# business_as_level1.topics.create!(name: "Topic 1.5 Entrepreneurs and Leaders - Part I", time: 8, unit: "Unit 1: Marketing and People")
# business_as_level1.topics.create!(name: "Topic 1.5 Entrepreneurs and Leaders - Part II", time: 7, unit: "Unit 1: Marketing and People")
# business_as_level1.topics.create!(name: "Unit 1 Assessment", time: 3, unit: "Unit 1: Marketing and People", has_grade: true, milestone: true)
# business_as_level1.topics.create!(name: "Topic 2.1 Planning a Business and Raising Finance - Part I", time: 9, unit: "Unit 2: Managing Business Activities")
# business_as_level1.topics.create!(name: "Topic 2.1 Planning a Business and Raising Finance - Part II", time: 8, unit: "Unit 2: Managing Business Activities")
# business_as_level1.topics.create!(name: "Topic 2.2 Financial Planning - Part I", time: 8, unit: "Unit 2: Managing Business Activities")
# business_as_level1.topics.create!(name: "Topic 2.2 Financial Planning - Part II", time: 11, unit: "Unit 2: Managing Business Activities")
# business_as_level1.topics.create!(name: "Topic 2.3 Managing Finance - Part I", time: 4, unit: "Unit 2: Managing Business Activities")
# business_as_level1.topics.create!(name: "Topic 2.3 Managing Finance - Part II", time: 7, unit: "Unit 2: Managing Business Activities")
# business_as_level1.topics.create!(name: "Topic 2.4 Resource Management - Part I", time: 8, unit: "Unit 2: Managing Business Activities")
# business_as_level1.topics.create!(name: "Topic 2.4 Resource Management - Part II", time: 7, unit: "Unit 2: Managing Business Activities")
# business_as_level1.topics.create!(name: "Topic 2.5 External Influences - Part I", time: 7, unit: "Unit 2: Managing Business Activities")
# business_as_level1.topics.create!(name: "Topic 2.5 External Influences - Part II", time: 4, unit: "Unit 2: Managing Business Activities")
# business_as_level1.topics.create!(name: "Unit 2 Assessment", time: 2, unit: "Unit 2: Managing Business Activities", has_grade: true, milestone: true)
# business_as_level1.topics.create!(name: "50% Mock Exam", time: 2, unit: "Unit 2: Managing Business Activities", milestone: true, has_grade: true, Mock50: true)


# business_as_level2 = Subject.create!(
#   name: "Business AS Level 2",
#   category: :as,
#   )

# business_as_level2.topics.create!(name: "Topic 3.1 Business Objectives and Strategy - Part I", time: 7, unit: "Unit 3: Business Decisions and Strategy")
# business_as_level2.topics.create!(name: "Topic 3.1 Business Objectives and Strategy - Part II", time: 8, unit: "Unit 3: Business Decisions and Strategy")
# business_as_level2.topics.create!(name: "Topic 3.2 Business Growth - Part I", time: 6, unit: "Unit 3: Business Decisions and Strategy")
# business_as_level2.topics.create!(name: "Topic 3.2 Business Growth - Part II", time: 7, unit: "Unit 3: Business Decisions and Strategy")
# business_as_level2.topics.create!(name: "Topic 3.3 Decision-Making Techniques - Part I", time: 11, unit: "Unit 3: Business Decisions and Strategy")
# business_as_level2.topics.create!(name: "Topic 3.3 Decision-Making Techniques - Part II", time: 10, unit: "Unit 3: Business Decisions and Strategy")
# business_as_level2.topics.create!(name: "Topic 3.4 Influences on Business Decisions - Part I", time: 5, unit: "Unit 3: Business Decisions and Strategy")
# business_as_level2.topics.create!(name: "Topic 3.4 Influences on Business Decisions - Part II", time: 7, unit: "Unit 3: Business Decisions and Strategy")
# business_as_level2.topics.create!(name: "Topic 3.5 Assessing Competitiveness - Part I", time: 4, unit: "Unit 3: Business Decisions and Strategy")
# business_as_level2.topics.create!(name: "Topic 3.5 Assessing Competitiveness - Part II", time: 6, unit: "Unit 3: Business Decisions and Strategy")
# business_as_level2.topics.create!(name: "Topic 3.6 Managing Change", time: 6, unit: "Unit 3: Business Decisions and Strategy")
# business_as_level2.topics.create!(name: "Unit 3 Assessment", time: 2, unit: "Unit 3: Business Decisions and Strategy", has_grade: true, milestone: true)
# business_as_level2.topics.create!(name: "Topic 4.1 Globalisation - Part I", time: 8, unit: "Unit 4: Global Business")
# business_as_level2.topics.create!(name: "Topic 4.1 Globalisation - Part II", time: 7, unit: "Unit 4: Global Business")
# business_as_level2.topics.create!(name: "Topic 4.2 Global Markets and Business Expansion - Part I", time: 8, unit: "Unit 4: Global Business")
# business_as_level2.topics.create!(name: "Topic 4.2 Global Markets and Business Expansion - Part II", time: 7, unit: "Unit 4: Global Business")
# business_as_level2.topics.create!(name: "Topic 4.3 Global Marketing - Part I", time: 6, unit: "Unit 4: Global Business")
# business_as_level2.topics.create!(name: "Topic 4.3 Global Marketing - Part II", time: 4, unit: "Unit 4: Global Business")
# business_as_level2.topics.create!(name: "Topic 4.4 Global Industries and Companies - Part I", time: 6, unit: "Unit 4: Global Business")
# business_as_level2.topics.create!(name: "Topic 4.4 Global Industries and Companies - Part II", time: 4, unit: "Unit 4: Global Business")
# business_as_level2.topics.create!(name: "Unit 4 Assessment", time: 2, unit: "Unit 4: Global Business", has_grade: true, milestone: true)
# business_as_level2.topics.create!(name: "100% Mock Exam", time: 2, unit: "Unit 4: Global Business", milestone: true, has_grade: true, Mock100: true)



# economics_a_level = Subject.create!(
#   name: "Economics A Level",
#   category: :al,
#   )

#   economics_a_level.topics.create!(name: "Unit 1 - Markets in Action", time: 5, unit: "Unit 1 - Markets in Action")
#   economics_a_level.topics.create!(name: "Topic 1.1 Introductory Concepts: Part I", time: 7, unit: "Unit 1 - Markets in Action")
#   economics_a_level.topics.create!(name: "Topic 1.1 Introductory Concepts: Part II", time: 7, unit: "Unit 1 - Markets in Action")
#   economics_a_level.topics.create!(name: "Topic 1.1 Introductory Concepts: Part III", time: 7, unit: "Unit 1 - Markets in Action")
#   economics_a_level.topics.create!(name: "Topic 1.2 Consumer Behaviour and Demand: Part I", time: 9, unit: "Unit 1 - Markets in Action")
#   economics_a_level.topics.create!(name: "Topic 1.2 Consumer Behaviour and Demand: Part II", time: 5, unit: "Unit 1 - Markets in Action")
#   economics_a_level.topics.create!(name: "Topic 1.3 Supply", time: 8, unit: "Unit 1 - Markets in Action")
#   economics_a_level.topics.create!(name: "Topic 1.4 Price Determination: Part I", time: 6, unit: "Unit 1 - Markets in Action")
#   economics_a_level.topics.create!(name: "Topic 1.4 Price Determination: Part II", time: 7, unit: "Unit 1 - Markets in Action")
#   economics_a_level.topics.create!(name: "Topic 1.5 Market Failure: Part I", time: 7, unit: "Unit 1 - Markets in Action")
#   economics_a_level.topics.create!(name: "Topic 1.5 Market Failure: Part II", time: 6, unit: "Unit 1 - Markets in Action")
#   economics_a_level.topics.create!(name: "Topic 1.5 Market Failure: Part III", time: 8, unit: "Unit 1 - Markets in Action")
#   economics_a_level.topics.create!(name: "Topic 1.6 Government Intervention in Markets", time: 8, unit: "Unit 1 - Markets in Action")
#   economics_a_level.topics.create!(name: "Unit 1 Assessments", time: 4, unit: "Unit 1 - Markets in Action", has_grade: true)
#   economics_a_level.topics.create!(name: "Unit 2 - Macroeconomic Performance And Policiy", time: 5, unit: "Unit 2 - Macroeconomic Performance And Policiy")
#   economics_a_level.topics.create!(name: "Topic 2.1 Measures of Economic Performance: Part I", time: 7, unit: "Unit 2 - Macroeconomic Performance And Policiy")
#   economics_a_level.topics.create!(name: "Topic 2.1 Measures of Economic Performance: Part II", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy")
#   economics_a_level.topics.create!(name: "Topic 2.2 Aggregate Demand (AD): Part I", time: 8, unit: "Unit 2 - Macroeconomic Performance And Policiy")
#   economics_a_level.topics.create!(name: "Topic 2.2 Aggregate Demand (AD): Part II", time: 7, unit: "Unit 2 - Macroeconomic Performance And Policiy")
#   economics_a_level.topics.create!(name: "Topic 2.3 Aggregate Supply (AS)", time: 9, unit: "Unit 2 - Macroeconomic Performance And Policiy")
#   economics_a_level.topics.create!(name: "Topic 2.4 National Income: Part I", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy")
#   economics_a_level.topics.create!(name: "Topic 2.4 National Income: Part II", time: 7, unit: "Unit 2 - Macroeconomic Performance And Policiy")
#   economics_a_level.topics.create!(name: "Topic 2.5 Economic Growth: Part I", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy")
#   economics_a_level.topics.create!(name: "Topic 2.5 Economic Growth: Part II", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy")
#   economics_a_level.topics.create!(name: "Topic 2.6 Macroeconomic Objectives and Policies: Part I", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy")
#   economics_a_level.topics.create!(name: "Topic 2.6 Macroeconomic Objectives and Policies: Part II", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy")
#   economics_a_level.topics.create!(name: "Unit 2 Assessments: Exam Preparation", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy", has_grade: true)
#   economics_a_level.topics.create!(name: "Mock Exam 50%", time: 2, unit: "Unit 2 - Macroeconomic Performance And Policiy", milestone: true, has_grade: true, Mock50: true)
#   economics_a_level.topics.create!(name: "Unit 3 - Business Behaviour", time: 5, unit: "Unit 3 - Business Behaviour")
#   economics_a_level.topics.create!(name: "Topic 3.1 Types and Sizes of Business", time: 6, unit: "Unit 3 - Business Behaviour")
#   economics_a_level.topics.create!(name: "Topic 3.2 Revenues, Costs and Profits: Part I", time: 6, unit: "Unit 3 - Business Behaviour")
#   economics_a_level.topics.create!(name: "Topic 3.2 Revenues, Costs and Profits: Part II", time: 7, unit: "Unit 3 - Business Behaviour")
#   economics_a_level.topics.create!(name: "Topic 3.3 Market Structures and Contestability: Part I", time: 6, unit: "Unit 3 - Business Behaviour")
#   economics_a_level.topics.create!(name: "Topic 3.3 Market Structures and Contestability: Part II", time: 6, unit: "Unit 3 - Business Behaviour")
#   economics_a_level.topics.create!(name: "Topic 3.3 Market Structures and Contestability: Part III", time: 9, unit: "Unit 3 - Business Behaviour")
#   economics_a_level.topics.create!(name: "Topic 3.4 Labour Markets", time: 10, unit: "Unit 3 - Business Behaviour")
#   economics_a_level.topics.create!(name: "Topic 3.5 Government Intervention", time: 6, unit: "Unit 3 - Business Behaviour")
#   economics_a_level.topics.create!(name: "Unit 3 Assessments", time: 2, unit: "Unit 3 - Business Behaviour", has_grade: true)
#   economics_a_level.topics.create!(name: "Unit 4  - Developments in the Global Economy", time: 5, unit: "Unit 4  - Developments in the Global Economy")
#   economics_a_level.topics.create!(name: "Topic 4.1 Causes and Effects of Globalisation", time: 4, unit: "Unit 4  - Developments in the Global Economy")
#   economics_a_level.topics.create!(name: "Topic 4.2 Trade and the Global Economy - Part I", time: 8, unit: "Unit 4  - Developments in the Global Economy")
#   economics_a_level.topics.create!(name: "Topic 4.2 Trade and the Global Economy - Part II", time: 8, unit: "Unit 4  - Developments in the Global Economy")
#   economics_a_level.topics.create!(name: "Topic 4.3 Balance of Payments, Exchange Rates and International Competitiveness", time: 8, unit: "Unit 4  - Developments in the Global Economy")
#   economics_a_level.topics.create!(name: "Topic 4.4 Poverty and Inequality", time: 7, unit: "Unit 4  - Developments in the Global Economy")
#   economics_a_level.topics.create!(name: "Topic 4.5 Role of the State in the Macroeconomy - Part I", time: 6, unit: "Unit 4  - Developments in the Global Economy")
#   economics_a_level.topics.create!(name: "Topic 4.5 Role of the State in the Macroeconomy - Part II", time: 4, unit: "Unit 4  - Developments in the Global Economy")
#   economics_a_level.topics.create!(name: "Topic 4.6 Growth and Development in Developing, Emerging and Developed Economies", time: 8, unit: "Unit 4  - Developments in the Global Economy")
#   economics_a_level.topics.create!(name: "Unit 4 Assessments", time: 6, unit: "Unit 4  - Developments in the Global Economy", has_grade: true)
#   economics_a_level.topics.create!(name: "Mock Exam 100%", time: 2, unit: "Unit 4  - Developments in the Global Economy", milestone: true, has_grade: true, Mock100: true)

# economics_as_level1 = Subject.create!(
#   name: "Economics AS Level 1",
#   category: :as,
#   )

# economics_as_level1.topics.create!(name: "Topic 1.1 Introductory Concepts: Part I", time: 7, unit: "Unit 1 - Markets in Action")
# economics_as_level1.topics.create!(name: "Topic 1.1 Introductory Concepts: Part II", time: 7, unit: "Unit 1 - Markets in Action")
# economics_as_level1.topics.create!(name: "Topic 1.1 Introductory Concepts: Part III", time: 7, unit: "Unit 1 - Markets in Action")
# economics_as_level1.topics.create!(name: "Topic 1.2 Consumer Behaviour and Demand: Part I", time: 9, unit: "Unit 1 - Markets in Action")
# economics_as_level1.topics.create!(name: "Topic 1.2 Consumer Behaviour and Demand: Part II", time: 5, unit: "Unit 1 - Markets in Action")
# economics_as_level1.topics.create!(name: "Topic 1.3 Supply", time: 8, unit: "Unit 1 - Markets in Action")
# economics_as_level1.topics.create!(name: "Topic 1.4 Price Determination: Part I", time: 6, unit: "Unit 1 - Markets in Action")
# economics_as_level1.topics.create!(name: "Topic 1.4 Price Determination: Part II", time: 7, unit: "Unit 1 - Markets in Action")
# economics_as_level1.topics.create!(name: "Topic 1.5 Market Failure: Part I", time: 7, unit: "Unit 1 - Markets in Action")
# economics_as_level1.topics.create!(name: "Topic 1.5 Market Failure: Part II", time: 6, unit: "Unit 1 - Markets in Action")
# economics_as_level1.topics.create!(name: "Topic 1.5 Market Failure: Part III", time: 8, unit: "Unit 1 - Markets in Action")
# economics_as_level1.topics.create!(name: "Topic 1.6 Government Intervention in Markets", time: 8, unit: "Unit 1 - Markets in Action")
# economics_as_level1.topics.create!(name: "Unit 1 Assessments", time: 4, unit: "Unit 1 - Markets in Action", has_grade: true, milestone: true)
# economics_as_level1.topics.create!(name: "Topic 2.1 Measures of Economic Performance: Part I", time: 7, unit: "Unit 2 - Macroeconomic Performance And Policiy")
# economics_as_level1.topics.create!(name: "Topic 2.1 Measures of Economic Performance: Part II", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy")
# economics_as_level1.topics.create!(name: "Topic 2.2 Aggregate Demand (AD): Part I", time: 8, unit: "Unit 2 - Macroeconomic Performance And Policiy")
# economics_as_level1.topics.create!(name: "Topic 2.2 Aggregate Demand (AD): Part II", time: 7, unit: "Unit 2 - Macroeconomic Performance And Policiy")
# economics_as_level1.topics.create!(name: "Topic 2.3 Aggregate Supply (AS)", time: 9, unit: "Unit 2 - Macroeconomic Performance And Policiy")
# economics_as_level1.topics.create!(name: "Topic 2.4 National Income: Part I", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy")
# economics_as_level1.topics.create!(name: "Topic 2.4 National Income: Part II", time: 7, unit: "Unit 2 - Macroeconomic Performance And Policiy")
# economics_as_level1.topics.create!(name: "Topic 2.5 Economic Growth: Part I", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy")
# economics_as_level1.topics.create!(name: "Topic 2.5 Economic Growth: Part II", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy")
# economics_as_level1.topics.create!(name: "Topic 2.6 Macroeconomic Objectives and Policies: Part I", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy")
# economics_as_level1.topics.create!(name: "Topic 2.6 Macroeconomic Objectives and Policies: Part II", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy")
# economics_as_level1.topics.create!(name: "Unit 2 Assessments: Exam Preparation", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy", has_grade: true, milestone: true)
# economics_as_level1.topics.create!(name: "Mock Exam 50%", time: 2, unit: "Unit 2 - Macroeconomic Performance And Policiy", milestone: true, has_grade: true, Mock50: true)

# economics_as_level2 = Subject.create!(
#   name: "Economics AS Level 2",
#   category: :as,
#   )

# economics_as_level2.topics.create!(name: "Topic 3.1 Types and Sizes of Business", time: 6, unit: "Unit 3 - Business Behaviour")
# economics_as_level2.topics.create!(name: "Topic 3.2 Revenues, Costs and Profits: Part I", time: 6, unit: "Unit 3 - Business Behaviour")
# economics_as_level2.topics.create!(name: "Topic 3.2 Revenues, Costs and Profits: Part II", time: 7, unit: "Unit 3 - Business Behaviour")
# economics_as_level2.topics.create!(name: "Topic 3.3 Market Structures and Contestability: Part I", time: 6, unit: "Unit 3 - Business Behaviour")
# economics_as_level2.topics.create!(name: "Topic 3.3 Market Structures and Contestability: Part II", time: 6, unit: "Unit 3 - Business Behaviour")
# economics_as_level2.topics.create!(name: "Topic 3.3 Market Structures and Contestability: Part III", time: 9, unit: "Unit 3 - Business Behaviour")
# economics_as_level2.topics.create!(name: "Topic 3.4 Labour Markets", time: 10, unit: "Unit 3 - Business Behaviour")
# economics_as_level2.topics.create!(name: "Topic 3.5 Government Intervention", time: 6, unit: "Unit 3 - Business Behaviour")
# economics_as_level2.topics.create!(name: "Unit 3 Assessments", time: 2, unit: "Unit 3 - Business Behaviour", has_grade: true, milestone: true)
# economics_as_level2.topics.create!(name: "Topic 4.1 Causes and Effects of Globalisation", time: 4, unit: "Unit 4  - Developments in the Global Economy")
# economics_as_level2.topics.create!(name: "Topic 4.2 Trade and the Global Economy - Part I", time: 8, unit: "Unit 4  - Developments in the Global Economy")
# economics_as_level2.topics.create!(name: "Topic 4.2 Trade and the Global Economy - Part II", time: 8, unit: "Unit 4  - Developments in the Global Economy")
# economics_as_level2.topics.create!(name: "Topic 4.3 Balance of Payments, Exchange Rates and International Competitiveness", time: 8, unit: "Unit 4  - Developments in the Global Economy")
# economics_as_level2.topics.create!(name: "Topic 4.4 Poverty and Inequality", time: 7, unit: "Unit 4  - Developments in the Global Economy")
# economics_as_level2.topics.create!(name: "Topic 4.5 Role of the State in the Macroeconomy - Part I", time: 6, unit: "Unit 4  - Developments in the Global Economy")
# economics_as_level2.topics.create!(name: "Topic 4.5 Role of the State in the Macroeconomy - Part II", time: 4, unit: "Unit 4  - Developments in the Global Economy")
# economics_as_level2.topics.create!(name: "Topic 4.6 Growth and Development in Developing, Emerging and Developed Economies", time: 8, unit: "Unit 4  - Developments in the Global Economy")
# economics_as_level2.topics.create!(name: "Unit 4 Assessments", time: 6, unit: "Unit 4  - Developments in the Global Economy", has_grade: true, milestone: true)
# economics_as_level2.topics.create!(name: "Mock Exam 100%", time: 2, unit: "Unit 4  - Developments in the Global Economy", milestone: true, has_grade: true, Mock100: true)


#   psychology_a_level = Subject.create!(
#     name: "Psychology A Level",
#     category: :al,
#     )

#     psychology_a_level.topics.create!(name: "Topic A - Social Psychology: Obedience [Part 1]", time: 12, unit: "Unit 1: Social and Cognitive Psychology")
#     psychology_a_level.topics.create!(name: "Topic A - Social Psychology: Conformity and Minority Influence [Part 2]", time: 10, unit: "Unit 1: Social and Cognitive Psychology")
#     psychology_a_level.topics.create!(name: "Topic A - Social Psychology: Studies/Research  [Part 3]", time: 6, unit: "Unit 1: Social and Cognitive Psychology")
#     psychology_a_level.topics.create!(name: "Topic A - Social Psychology: Research Methods I [Part 4]", time: 15, unit: "Unit 1: Social and Cognitive Psychology")
#     psychology_a_level.topics.create!(name: "Topic A - Social Psychology: Revision/ Assignments [Part 5]", time: 21, unit: "Unit 1: Social and Cognitive Psychology")
#     psychology_a_level.topics.create!(name: "Topic B - Cognitive Psychology: Memory [Part 1]", time: 14, unit: "Unit 1: Social and Cognitive Psychology")
#     psychology_a_level.topics.create!(name: "Topic B - Cognitive Psychology: Studies/Research [Part 2]", time: 6, unit: "Unit 1: Social and Cognitive Psychology")
#     psychology_a_level.topics.create!(name: "Topic B - Cognitive Psychology: Research Methods II [Part 3]", time: 12, unit: "Unit 1: Social and Cognitive Psychology")
#     psychology_a_level.topics.create!(name: "Topic B - Cognitive Psychology: Revision/ Assignments [Part 4]", time: 3, unit: "Unit 1: Social and Cognitive Psychology")
#     psychology_a_level.topics.create!(name: "Topic C - Biological Psychology:  Structure & Function of Brain  [Part 1]", time: 5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#     psychology_a_level.topics.create!(name: "Topic C - Biological Psychology: Aggression – The Role of Genes and Hormones [Part 2]", time: 5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#     psychology_a_level.topics.create!(name: "Topic C - Biological Psychology: Body Rhythms [Part 3]", time: 5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#     psychology_a_level.topics.create!(name: "Topic C - Biological Psychology: Body Rhythms – Studies/Research  [Part 4]", time: 6, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#     psychology_a_level.topics.create!(name: "Topic C - Biological Psychology: Research Methods III [Part 5]", time: 10, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#     psychology_a_level.topics.create!(name: "Topic C - Revision/ Assignments [Part 6]", time: 9, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#     psychology_a_level.topics.create!(name: "Topic D - Learning Theories & Development: Behaviourism & Conditioning [Part 1]", time: 7, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#     psychology_a_level.topics.create!(name: "Topic D – Learning Theories & Development: Social Learning Theory [Part 2]", time: 5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#     psychology_a_level.topics.create!(name: "Topic D – Learning Theories & Development: Freud’s Theory of Development [Part 3]", time: 5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#     psychology_a_level.topics.create!(name: "Topic D – Learning Theories & Development: Therapies/Treatment [Part 4]", time: 5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#     psychology_a_level.topics.create!(name: "Topic D – Learning Theories & Development: Studies/Research  [Part 5]", time: 6, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#     psychology_a_level.topics.create!(name: "Topic D – Learning Theories & Development: Research Methods IV [Part 6]", time: 16, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#     psychology_a_level.topics.create!(name: "Topic D – Learning Theories & Development: Revision/ Assignments  [Part 7]", time: 11.5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#     psychology_a_level.topics.create!(name: "50% Mock Exam", time: 3.5, unit: "Unit 2: Biological Psychology, Learning theories & Development", milestone: true, has_grade: true, Mock50: true)
#     psychology_a_level.topics.create!(name: "Topic E - Developmental Psychology - Attachment [Part 1]", time: 8.5, unit: "Unit 3: Applications of Psychology")
#     psychology_a_level.topics.create!(name: "Topic E - Developmental Psychology: Cognitive and Language Development [Part 2]", time: 10, unit: "Unit 3: Applications of Psychology")
#     psychology_a_level.topics.create!(name: "Topic E - Developmental Psychology: Social and Emotional Development [Part 3]", time: 6, unit: "Unit 3: Applications of Psychology")
#     psychology_a_level.topics.create!(name: "Topic E - Developmental Psychology: Learning theories [Part 4]", time: 5, unit: "Unit 3: Applications of Psychology")
#     psychology_a_level.topics.create!(name: "Topic E - Developmental Psychology: Studies/Research  [Part 5]", time: 6, unit: "Unit 3: Applications of Psychology")
#     psychology_a_level.topics.create!(name: "Topic E - Developmental Psychology: Research Methods V/ Issues [Part 6]", time: 6, unit: "Unit 3: Applications of Psychology")
#     psychology_a_level.topics.create!(name: "Topic E – Developmental Psychology: Revision/ Assignments [Part 7]", time: 2.5, unit: "Unit 3: Applications of Psychology")
#     psychology_a_level.topics.create!(name: "Topic F - Criminal Psychology: Explanations for Crime and Anti-social Behaviour [Part 1]", time: 6, unit: "Unit 3: Applications of Psychology")
#     psychology_a_level.topics.create!(name: "Topic F - Criminal Psychology: (Understanding) the Offender [Part 2]", time: 5, unit: "Unit 3: Applications of Psychology")
#     psychology_a_level.topics.create!(name: "Topic F – Criminal Psychology: Factors that influence the identification of Offenders [Part 3]", time: 6, unit: "Unit 3: Applications of Psychology")
#     psychology_a_level.topics.create!(name: "Topic F – Criminal Psychology: Treatment [Part 4]", time: 5, unit: "Unit 3: Applications of Psychology")
#     psychology_a_level.topics.create!(name: "Topic F – Criminal Psychology: Studies/Research  [Part 5]", time: 6, unit: "Unit 3: Applications of Psychology")
#     psychology_a_level.topics.create!(name: "Topic F – Criminal Psychology: Assignments", time: 4.5, unit: "Unit 3: Applications of Psychology")
#     psychology_a_level.topics.create!(name: "Topic G - Clinical Psychology: Diagnosis - Definitions and Debates [Part 1]", time: 10, unit: "Unit 4: Clinical Psychology & Psychological Skills")
#     psychology_a_level.topics.create!(name: "Topic G - Clinical Psychology: Mental Health Disorders and Explanations [Part 2]", time: 10, unit: "Unit 4: Clinical Psychology & Psychological Skills")
#     psychology_a_level.topics.create!(name: "Topic G - Clinical Psychology: Treatment [Part 3]", time: 10, unit: "Unit 4: Clinical Psychology & Psychological Skills")
#     psychology_a_level.topics.create!(name: "Topic G - Clinical Psychology: Studies/ Research [Part 4]", time: 6, unit: "Unit 4: Clinical Psychology & Psychological Skills")
#     psychology_a_level.topics.create!(name: "Topic G - Clinical Psychology: Research Methods VII [Part 5]", time: 10, unit: "Unit 4: Clinical Psychology & Psychological Skills")
#     psychology_a_level.topics.create!(name: "Topic G - Clinical Psychology: Revision/ Assignments [Part 6]", time: 10.5, unit: "Unit 4: Clinical Psychology & Psychological Skills")
#     psychology_a_level.topics.create!(name: "Topic H - Psychological Skills: Key questions in Society [Part 1]", time: 16, unit: "Unit 4: Clinical Psychology & Psychological Skills")
#     psychology_a_level.topics.create!(name: "Topic H - Psychological Skills: Issues & Debates in Psychology [Part 2]", time: 24, unit: "Unit 4: Clinical Psychology & Psychological Skills")
#     psychology_a_level.topics.create!(name: "Topic H - Psychological Skills: Summary of Research Methods [Part 3]", time: 18, unit: "Unit 4: Clinical Psychology & Psychological Skills")
#     psychology_a_level.topics.create!(name: "Topic H - Psychological Skills: Assignments", time: 4, unit: "Unit 4: Clinical Psychology & Psychological Skills")
#     psychology_a_level.topics.create!(name: "100% Mock Exam", time: 8, unit: "Unit 4: Clinical Psychology & Psychological Skills", milestone: true, has_grade: true, Mock100: true)

# psychology_as_level1 = Subject.create!(
#   name: "Psychology AS Level 1",
#   category: :as,
#   )

#   psychology_as_level1.topics.create!(name: "Topic A - Social Psychology: Obedience [Part 1]", time: 12, unit: "Unit 1: Social and Cognitive Psychology")
#   psychology_as_level1.topics.create!(name: "Topic A - Social Psychology: Conformity and Minority Influence [Part 2]", time: 10, unit: "Unit 1: Social and Cognitive Psychology")
#   psychology_as_level1.topics.create!(name: "Topic A - Social Psychology: Studies/Research  [Part 3]", time: 6, unit: "Unit 1: Social and Cognitive Psychology")
#   psychology_as_level1.topics.create!(name: "Topic A - Social Psychology: Research Methods I [Part 4]", time: 15, unit: "Unit 1: Social and Cognitive Psychology")
#   psychology_as_level1.topics.create!(name: "Topic A - Social Psychology: Revision/ Assignments [Part 5]", time: 21, unit: "Unit 1: Social and Cognitive Psychology")
#   psychology_as_level1.topics.create!(name: "Topic B - Cognitive Psychology: Memory [Part 1]", time: 14, unit: "Unit 1: Social and Cognitive Psychology")
#   psychology_as_level1.topics.create!(name: "Topic B - Cognitive Psychology: Studies/Research [Part 2]", time: 6, unit: "Unit 1: Social and Cognitive Psychology")
#   psychology_as_level1.topics.create!(name: "Topic B - Cognitive Psychology: Research Methods II [Part 3]", time: 12, unit: "Unit 1: Social and Cognitive Psychology")
#   psychology_as_level1.topics.create!(name: "Topic B - Cognitive Psychology: Revision/ Assignments [Part 4]", time: 3, unit: "Unit 1: Social and Cognitive Psychology")
#   psychology_as_level1.topics.create!(name: "Topic C - Biological Psychology:  Structure & Function of Brain  [Part 1]", time: 5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#   psychology_as_level1.topics.create!(name: "Topic C - Biological Psychology: Aggression - The Role of Genes and Hormones [Part 2]", time: 5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#   psychology_as_level1.topics.create!(name: "Topic C - Biological Psychology: Body Rhythms [Part 3]", time: 5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#   psychology_as_level1.topics.create!(name: "Topic C - Biological Psychology: Body Rhythms - Studies/Research  [Part 4]", time: 6, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#   psychology_as_level1.topics.create!(name: "Topic C - Biological Psychology: Research Methods III [Part 5]", time: 10, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#   psychology_as_level1.topics.create!(name: "Topic C - Revision/ Assignments [Part 6]", time: 9, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#   psychology_as_level1.topics.create!(name: "Topic D - Learning Theories & Development: Behaviourism & Conditioning [Part 1]", time: 7, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#   psychology_as_level1.topics.create!(name: "Topic D - Learning Theories & Development: Social Learning Theory [Part 2]", time: 5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#   psychology_as_level1.topics.create!(name: "Topic D - Learning Theories & Development: Freud's Theory of Development [Part 3]", time: 5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#   psychology_as_level1.topics.create!(name: "Topic D - Learning Theories & Development: Therapies/Treatment [Part 4]", time: 5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#   psychology_as_level1.topics.create!(name: "Topic D - Learning Theories & Development: Studies/Research  [Part 5]", time: 6, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#   psychology_as_level1.topics.create!(name: "Topic D - Learning Theories & Development: Research Methods IV [Part 6]", time: 16, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#   psychology_as_level1.topics.create!(name: "Topic D - Learning Theories & Development: Revision/ Assignments  [Part 7]", time: 11.5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
#   psychology_as_level1.topics.create!(name: "50% Mock Exam", time: 3.5, unit: "Unit 2: Biological Psychology, Learning theories & Development", milestone: true, has_grade: true, Mock50: true)

# psychology_as_level2 = Subject.create!(
#   name: "Psychology AS Level 2",
#   category: :as,
#   )

#   psychology_as_level2.topics.create!(name: "Topic E - Developmental Psychology - Attachment [Part 1]", time: 8.5, unit: "Unit 3: Applications of Psychology")
#   psychology_as_level2.topics.create!(name: "Topic E - Developmental Psychology: Cognitive and Language Development [Part 2]", time: 10, unit: "Unit 3: Applications of Psychology")
#   psychology_as_level2.topics.create!(name: "Topic E - Developmental Psychology: Social and Emotional Development [Part 3]", time: 6, unit: "Unit 3: Applications of Psychology")
#   psychology_as_level2.topics.create!(name: "Topic E - Developmental Psychology: Learning theories [Part 4]", time: 5, unit: "Unit 3: Applications of Psychology")
#   psychology_as_level2.topics.create!(name: "Topic E - Developmental Psychology: Studies/Research  [Part 5]", time: 6, unit: "Unit 3: Applications of Psychology")
#   psychology_as_level2.topics.create!(name: "Topic E - Developmental Psychology: Research Methods V/ Issues [Part 6]", time: 6, unit: "Unit 3: Applications of Psychology")
#   psychology_as_level2.topics.create!(name: "Topic E - Developmental Psychology: Revision/ Assignments [Part 7]", time: 2.5, unit: "Unit 3: Applications of Psychology")
#   psychology_as_level2.topics.create!(name: "Topic F - Criminal Psychology: Explanations for Crime and Anti-social Behaviour [Part 1]", time: 6, unit: "Unit 3: Applications of Psychology")
#   psychology_as_level2.topics.create!(name: "Topic F - Criminal Psychology: (Understanding) the Offender [Part 2]", time: 5, unit: "Unit 3: Applications of Psychology")
#   psychology_as_level2.topics.create!(name: "Topic F - Criminal Psychology: Factors that influence the identification of Offenders [Part 3]", time: 6, unit: "Unit 3: Applications of Psychology")
#   psychology_as_level2.topics.create!(name: "Topic F - Criminal Psychology: Treatment [Part 4]", time: 5, unit: "Unit 3: Applications of Psychology")
#   psychology_as_level2.topics.create!(name: "Topic F - Criminal Psychology: Studies/Research  [Part 5]", time: 6, unit: "Unit 3: Applications of Psychology")
#   psychology_as_level2.topics.create!(name: "Topic F - Criminal Psychology: Assignments", time: 4.5, unit: "Unit 3: Applications of Psychology", milestone: true, has_grade: true)
#   psychology_as_level2.topics.create!(name: "Topic G - Clinical Psychology: Diagnosis - Definitions and Debates [Part 1]", time: 10, unit: "Unit 4: Clinical Psychology & Psychological Skills")
#   psychology_as_level2.topics.create!(name: "Topic G - Clinical Psychology: Mental Health Disorders and Explanations [Part 2]", time: 10, unit: "Unit 4: Clinical Psychology & Psychological Skills")
#   psychology_as_level2.topics.create!(name: "Topic G - Clinical Psychology: Treatment [Part 3]", time: 10, unit: "Unit 4: Clinical Psychology & Psychological Skills")
#   psychology_as_level2.topics.create!(name: "Topic G - Clinical Psychology: Studies/ Research [Part 4]", time: 6, unit: "Unit 4: Clinical Psychology & Psychological Skills")
#   psychology_as_level2.topics.create!(name: "Topic G - Clinical Psychology: Research Methods VII [Part 5]", time: 10, unit: "Unit 4: Clinical Psychology & Psychological Skills")
#   psychology_as_level2.topics.create!(name: "Topic G - Clinical Psychology: Revision/ Assignments [Part 6]", time: 10.5, unit: "Unit 4: Clinical Psychology & Psychological Skills", milestone: true, has_grade: true)
#   psychology_as_level2.topics.create!(name: "Topic H - Psychological Skills: Key questions in Society [Part 1]", time: 16, unit: "Unit 4: Clinical Psychology & Psychological Skills")
#   psychology_as_level2.topics.create!(name: "Topic H - Psychological Skills: Issues & Debates in Psychology [Part 2]", time: 24, unit: "Unit 4: Clinical Psychology & Psychological Skills")
#   psychology_as_level2.topics.create!(name: "Topic H - Psychological Skills: Summary of Research Methods [Part 3]", time: 18, unit: "Unit 4: Clinical Psychology & Psychological Skills")
#   psychology_as_level2.topics.create!(name: "Topic H - Psychological Skills: Assignments", time: 4, unit: "Unit 4: Clinical Psychology & Psychological Skills", milestone: true, has_grade: true)
#   psychology_as_level2.topics.create!(name: "100% Mock Exam", time: 8, unit: "Unit 4: Clinical Psychology & Psychological Skills", milestone: true, has_grade: true, Mock100: true)


# sociology_a_level = Subject.create!(
#   name: "Sociology A Level",
#   category: :al,
#   )

#   sociology_a_level.topics.create!(name: "Topic 1.1: What is sociology?", time: 3, unit: "Unit 1: Introduction to sociology")
#   sociology_a_level.topics.create!(name: "Topic 1.2: Structural perspectives", time: 7, unit: "Unit 1: Introduction to sociology")
#   sociology_a_level.topics.create!(name: "Topic 1.3: Interactionist perspectives", time: 8, unit: "Unit 1: Introduction to sociology")
#   sociology_a_level.topics.create!(name: "Topic 2.1: Learning socialisation and the role of culture", time: 10, unit: "Unit 2: Socialisation and who we are")
#   sociology_a_level.topics.create!(name: "Topic 2.2: Social control and social order", time: 10, unit: "Unit 2: Socialisation and who we are")
#   sociology_a_level.topics.create!(name: "Topic 2.3: Social identity and different individual characteristics", time: 12, unit: "Unit 2: Socialisation and who we are")
#   sociology_a_level.topics.create!(name: "Topic 3.1: Introduction to research", time: 10, unit: "Unit 3: Research methods")
#   sociology_a_level.topics.create!(name: "Topic 3.2: Types of research methods", time: 10, unit: "Unit 3: Research methods")
#   sociology_a_level.topics.create!(name: "Topic 3.3: How to approach sociological research", time: 13, unit: "Unit 3: Research methods")
#   sociology_a_level.topics.create!(name: "Topic 4.1: Structuralist view of the family", time: 10, unit: "Unit 4: The family")
#   sociology_a_level.topics.create!(name: "Topic 4.2: Marriage, social change and family diversity", time: 10, unit: "Unit 4: The family")
#   sociology_a_level.topics.create!(name: "Topic 4.3: Gender and the family", time: 10, unit: "Unit 4: The family")
#   sociology_a_level.topics.create!(name: "Topic 4.4: Childhood and social change", time: 10, unit: "Unit 4: The family")
#   sociology_a_level.topics.create!(name: "Topic 4.5: Changes in life expectancy and motherhood/fatherhood", time: 13, unit: "Unit 4: The family")
#   sociology_a_level.topics.create!(name: "50% Mock Exam", time: 3, unit: "50% Mock Exam", milestone: true, has_grade: true, Mock50: true)
#   sociology_a_level.topics.create!(name: "Topic 5.1: Theories on the role of education", time: 8, unit: "Unit 5: Education")
#   sociology_a_level.topics.create!(name: "Topic 5.2: The role of education on social mobility", time: 7, unit: "Unit 5: Education")
#   sociology_a_level.topics.create!(name: "Topic 5.3: Influences on the curriculum", time: 8, unit: "Unit 5: Education")
#   sociology_a_level.topics.create!(name: "Topic 5.4: Intelligence and educational attainment", time: 7, unit: "Unit 5: Education")
#   sociology_a_level.topics.create!(name: "Topic 5.5: Social class and educational attainment", time: 7, unit: "Unit 5: Education")
#   sociology_a_level.topics.create!(name: "Topic 5.6: Ethnicity and educational attainment", time: 8, unit: "Unit 5: Education")
#   sociology_a_level.topics.create!(name: "Topic 5.7: Gender and educational attainment", time: 11, unit: "Unit 5: Education")
#   sociology_a_level.topics.create!(name: "Topic 6.1: The Media in a Global Perspective", time: 6, unit: "Unit 6: Media")
#   sociology_a_level.topics.create!(name: "Topic 6.2: Theories of the Media", time: 8, unit: "Unit 6: Media")
#   sociology_a_level.topics.create!(name: "Topic 6.3: The impact of the new Media", time: 7, unit: "Unit 6: Media")
#   sociology_a_level.topics.create!(name: "Topic 6.4: Media representations", time: 6, unit: "Unit 6: Media")
#   sociology_a_level.topics.create!(name: "Topic 6.5: Media Effects", time: 11, unit: "Unit 6: Media")
#   sociology_a_level.topics.create!(name: "Topic 7.1: Religion and society", time: 8, unit: "Unit 7: Religion")
#   sociology_a_level.topics.create!(name: "Topic 7.2: Religion and social order", time: 6, unit: "Unit 7: Religion")
#   sociology_a_level.topics.create!(name: "Topic 7.3: Gender and religion", time: 7, unit: "Unit 7: Religion")
#   sociology_a_level.topics.create!(name: "Topic 7.4: Religion and social change", time: 7, unit: "Unit 7: Religion")
#   sociology_a_level.topics.create!(name: "Topic 7.5: The secularization debate", time: 8, unit: "Unit 7: Religion")
#   sociology_a_level.topics.create!(name: "Topic 7.6: Religion and postmodernity", time: 8, unit: "Unit 7: Religion")
#   sociology_a_level.topics.create!(name: "Topic 8.1: Perspectives on globalisation", time: 8, unit: "Unit 8: Globalisation")
#   sociology_a_level.topics.create!(name: "Topic 8.2: Globalisation and identity", time: 7, unit: "Unit 8: Globalisation")
#   sociology_a_level.topics.create!(name: "Topic 8.3: Globalisation, power and politics", time: 8, unit: "Unit 8: Globalisation")
#   sociology_a_level.topics.create!(name: "Topic 8.4: Globalisation, poverty and inequality", time: 7, unit: "Unit 8: Globalisation")
#   sociology_a_level.topics.create!(name: "Topic 8.5: Globalisation and migration", time: 8, unit: "Unit 8: Globalisation")
#   sociology_a_level.topics.create!(name: "Topic 8.6: Globalisation and crime", time: 10, unit: "Unit 8: Globalisation")
#   sociology_a_level.topics.create!(name: "100% Mock Exam", time: 3, unit: "100% Mock Exam", milestone: true, has_grade: true, Mock100: true)

# sociology_as_level1 = Subject.create!(
#   name: "Sociology AS Level 1",
#   category: :as,
#   )

#   sociology_as_level1.topics.create!(name: "Topic 1.1: What is sociology?", time: 3, unit: "Unit 1: Introduction to sociology")
#   sociology_as_level1.topics.create!(name: "Topic 1.2: Structural perspectives", time: 7, unit: "Unit 1: Introduction to sociology")
#   sociology_as_level1.topics.create!(name: "Topic 1.3: Interactionist perspectives", time: 8, unit: "Unit 1: Introduction to sociology")
#   sociology_as_level1.topics.create!(name: "Topic 2.1: Learning socialisation and the role of culture", time: 10, unit: "Unit 2: Socialisation and who we are")
#   sociology_as_level1.topics.create!(name: "Topic 2.2: Social control and social order", time: 10, unit: "Unit 2: Socialisation and who we are")
#   sociology_as_level1.topics.create!(name: "Topic 2.3: Social identity and different individual characteristics", time: 12, unit: "Unit 2: Socialisation and who we are")
#   sociology_as_level1.topics.create!(name: "Topic 3.1: Introduction to research", time: 10, unit: "Unit 3: Research methods")
#   sociology_as_level1.topics.create!(name: "Topic 3.2: Types of research methods", time: 10, unit: "Unit 3: Research methods")
#   sociology_as_level1.topics.create!(name: "Topic 3.3: How to approach sociological research", time: 13, unit: "Unit 3: Research methods")
#   sociology_as_level1.topics.create!(name: "Topic 4.1: Structuralist view of the family", time: 10, unit: "Unit 4: The family")
#   sociology_as_level1.topics.create!(name: "Topic 4.2: Marriage, social change and family diversity", time: 10, unit: "Unit 4: The family")
#   sociology_as_level1.topics.create!(name: "Topic 4.3: Gender and the family", time: 10, unit: "Unit 4: The family")
#   sociology_as_level1.topics.create!(name: "Topic 4.4: Childhood and social change", time: 10, unit: "Unit 4: The family")
#   sociology_as_level1.topics.create!(name: "Topic 4.5: Changes in life expectancy and motherhood/fatherhood", time: 13, unit: "Unit 4: The family")
#   sociology_as_level1.topics.create!(name: "50% Mock Exam", time: 3, unit: "50% Mock Exam", milestone: true, has_grade: true, Mock50: true)

# sociology_as_level2 = Subject.create!(
#   name: "Sociology AS Level 2",
#   category: :as,
#   )

#   sociology_as_level2.topics.create!(name: "Topic 5.1: Theories on the role of education", time: 8, unit: "Unit 5: Education")
#   sociology_as_level2.topics.create!(name: "Topic 5.2: The role of education on social mobility", time: 7, unit: "Unit 5: Education")
#   sociology_as_level2.topics.create!(name: "Topic 5.3: Influences on the curriculum", time: 8, unit: "Unit 5: Education")
#   sociology_as_level2.topics.create!(name: "Topic 5.4: Intelligence and educational attainment", time: 7, unit: "Unit 5: Education")
#   sociology_as_level2.topics.create!(name: "Topic 5.5: Social class and educational attainment", time: 7, unit: "Unit 5: Education")
#   sociology_as_level2.topics.create!(name: "Topic 5.6: Ethnicity and educational attainment", time: 8, unit: "Unit 5: Education")
#   sociology_as_level2.topics.create!(name: "Topic 5.7: Gender and educational attainment", time: 11, unit: "Unit 5: Education")
#   sociology_as_level2.topics.create!(name: "Topic 6.1: The Media in a Global Perspective", time: 6, unit: "Unit 6: Media")
#   sociology_as_level2.topics.create!(name: "Topic 6.2: Theories of the Media", time: 8, unit: "Unit 6: Media")
#   sociology_as_level2.topics.create!(name: "Topic 6.3: The impact of the new Media", time: 7, unit: "Unit 6: Media")
#   sociology_as_level2.topics.create!(name: "Topic 6.4: Media representations", time: 6, unit: "Unit 6: Media")
#   sociology_as_level2.topics.create!(name: "Topic 6.5: Media Effects", time: 11, unit: "Unit 6: Media")
#   sociology_as_level2.topics.create!(name: "Topic 7.1: Religion and society", time: 8, unit: "Unit 7: Religion")
#   sociology_as_level2.topics.create!(name: "Topic 7.2: Religion and social order", time: 6, unit: "Unit 7: Religion")
#   sociology_as_level2.topics.create!(name: "Topic 7.3: Gender and religion", time: 7, unit: "Unit 7: Religion")
#   sociology_as_level2.topics.create!(name: "Topic 7.4: Religion and social change", time: 7, unit: "Unit 7: Religion")
#   sociology_as_level2.topics.create!(name: "Topic 7.5: The secularization debate", time: 8, unit: "Unit 7: Religion")
#   sociology_as_level2.topics.create!(name: "Topic 7.6: Religion and postmodernity", time: 8, unit: "Unit 7: Religion")
#   sociology_as_level2.topics.create!(name: "Topic 8.1: Perspectives on globalisation", time: 8, unit: "Unit 8: Globalisation")
#   sociology_as_level2.topics.create!(name: "Topic 8.2: Globalisation and identity", time: 7, unit: "Unit 8: Globalisation")
#   sociology_as_level2.topics.create!(name: "Topic 8.3: Globalisation, power and politics", time: 8, unit: "Unit 8: Globalisation")
#   sociology_as_level2.topics.create!(name: "Topic 8.4: Globalisation, poverty and inequality", time: 7, unit: "Unit 8: Globalisation")
#   sociology_as_level2.topics.create!(name: "Topic 8.5: Globalisation and migration", time: 8, unit: "Unit 8: Globalisation")
#   sociology_as_level2.topics.create!(name: "Topic 8.6: Globalisation and crime", time: 10, unit: "Unit 8: Globalisation")
#   sociology_as_level2.topics.create!(name: "100% Mock Exam", time: 3, unit: "100% Mock Exam", milestone: true, has_grade: true, Mock100: true)

# history_a_level = Subject.create!(
#   name: "History A Level",
#   category: :al,
#   )

#   history_a_level.topics.create!(name: "Topic 1.1: Political reaction and economic change –Alexander III and Nicholas II, 1881–1903", time: 20, unit: "Unit 1: Depth Study with Interpretations: Russia in Revolution (1881-1917)")
#   history_a_level.topics.create!(name: "Topic 1.2: The First Revolution and its impact, 1903–14", time: 20, unit: "Unit 1: Depth Study with Interpretations: Russia in Revolution (1881-1917)")
#   history_a_level.topics.create!(name: "Topic 1.3: The end of Romanov rule, 1914–17", time: 21, unit: "Unit 1: Depth Study with Interpretations: Russia in Revolution (1881-1917)")
#   history_a_level.topics.create!(name: "Topic 1.4: The Bolshevik seizure of power October 1917", time: 21, unit: "Unit 1: Depth Study with Interpretations: Russia in Revolution (1881-1917)")
#   history_a_level.topics.create!(name: "Unit 1 Assessment: Depth Study with Interpretations: Russia in Revolution (1881-1917)", time: 1, unit: "Unit 1: Depth Study with Interpretations: Russia in Revolution (1881-1917)")
#   history_a_level.topics.create!(name: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)", time: 20, unit: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)")
#   history_a_level.topics.create!(name: "Topic 2.1: Order and disorder,1900–76", time: 21, unit: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)")
#   history_a_level.topics.create!(name: "Topic 2.2: The impact of the world on China, 1900–76", time: 21, unit: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)")
#   history_a_level.topics.create!(name: "Topic 2.3: Economic changes, 1900–76", time: 21, unit: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)")
#   history_a_level.topics.create!(name: "Topic 2.4: Social and cultural changes, 1900–76", time: 2, unit: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)")
#   history_a_level.topics.create!(name: "Unit 2 Assessment: Breadth Study with Source Evaluation: China (1900-1976)", time: 1, unit: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)")
#   history_a_level.topics.create!(name: "50% Mock Exam  (Comprising of Units 1 and 2)", time: 2, unit: "50% Mock Exam  (Comprising of Units 1 and 2)", milestone: true, has_grade: true, Mock50: true)
#   history_a_level.topics.create!(name: "Topic 3.1: ‘Free at last’, 1865–77", time: 21, unit: "Unit 3: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)")
#   history_a_level.topics.create!(name: "Topic 3.2: The triumph of ‘Jim Crow’, 1883– c1900", time: 22, unit: "Unit 3: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)")
#   history_a_level.topics.create!(name: "Topic 3.3: Roosevelt and race relations, 1933–45", time: 21, unit: "Unit 3: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)")
#   history_a_level.topics.create!(name: "Topic 3.4: ‘I have a dream’, 1954–68", time: 22, unit: "Unit 3: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)")
#   history_a_level.topics.create!(name: "Topic 3.5: Race relations and Obama’s campaign for the presidency, c2000–09", time: 23.5, unit: "Unit 3: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)")
#   history_a_level.topics.create!(name: "Unit 3 Assessment: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)", time: 1, unit: "Unit 3: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)")
#   history_a_level.topics.create!(name: "Topic 4.1: Historical interpretations: what explains the outbreak, course and impact of the Korean War in the period 1950–53?", time: 21, unit: "Unit 4: International Study with Historical Interpretations: Option 1D: The Cold War and Hot War in Asia (1945-90)")
#   history_a_level.topics.create!(name: "Topic 4.2: The emergence of the Cold War in Southeast Asia, 1945–60", time: 20, unit: "Unit 4: International Study with Historical Interpretations: Option 1D: The Cold War and Hot War in Asia (1945-90)")
#   history_a_level.topics.create!(name: "Topic 4.3: War in Indo-China, 1960–73", time: 20, unit: "Unit 4: International Study with Historical Interpretations: Option 1D: The Cold War and Hot War in Asia (1945-90)")
#   history_a_level.topics.create!(name: "Topic 4.4: South-East Asia without the West: the fading of the Cold War, 1973–90", time: 21.5, unit: "Unit 4: International Study with Historical Interpretations: Option 1D: The Cold War and Hot War in Asia (1945-90)")
#   history_a_level.topics.create!(name: "Unit 4 Assessment:  International Study with Historical Interpretations: Option 1D: The Cold War and Hot War in Asia (1945-90)", time: 1, unit: "Unit 4: International Study with Historical Interpretations: Option 1D: The Cold War and Hot War in Asia (1945-90)")
#   history_a_level.topics.create!(name: "100% Mock Exam  - Comprising of Units 3 and 4", time: 2, unit: "100% Mock Exam  - Comprising of Units 3 and 4", milestone: true, has_grade: true, Mock100: true)

# history_as_level1 = Subject.create!(
#   name: "History AS Level 1",
#   category: :as,
#   )

#   history_as_level1.topics.create!(name: "Topic 1.1: Political reaction and economic change –Alexander III and Nicholas II, 1881–1903", time: 20, unit: "Unit 1: Depth Study with Interpretations: Russia in Revolution (1881-1917)")
#   history_as_level1.topics.create!(name: "Topic 1.2: The First Revolution and its impact, 1903–14", time: 20, unit: "Unit 1: Depth Study with Interpretations: Russia in Revolution (1881-1917)")
#   history_as_level1.topics.create!(name: "Topic 1.3: The end of Romanov rule, 1914–17", time: 21, unit: "Unit 1: Depth Study with Interpretations: Russia in Revolution (1881-1917)")
#   history_as_level1.topics.create!(name: "Topic 1.4: The Bolshevik seizure of power October 1917", time: 21, unit: "Unit 1: Depth Study with Interpretations: Russia in Revolution (1881-1917)")
#   history_as_level1.topics.create!(name: "Unit 1 Assessment: Depth Study with Interpretations: Russia in Revolution (1881-1917)", time: 1, unit: "Unit 1: Depth Study with Interpretations: Russia in Revolution (1881-1917)", milestone: true, has_grade: true)
#   history_as_level1.topics.create!(name: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)", time: 20, unit: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)")
#   history_as_level1.topics.create!(name: "Topic 2.1: Order and disorder,1900–76", time: 21, unit: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)")
#   history_as_level1.topics.create!(name: "Topic 2.2: The impact of the world on China, 1900–76", time: 21, unit: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)")
#   history_as_level1.topics.create!(name: "Topic 2.3: Economic changes, 1900–76", time: 21, unit: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)")
#   history_as_level1.topics.create!(name: "Topic 2.4: Social and cultural changes, 1900–76", time: 2, unit: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)")
#   history_as_level1.topics.create!(name: "Unit 2 Assessment: Breadth Study with Source Evaluation: China (1900-1976)", time: 1, unit: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)", milestone: true, has_grade: true)
#   history_as_level1.topics.create!(name: "50% Mock Exam  (Comprising of Units 1 and 2)", time: 2, unit: "50% Mock Exam  (Comprising of Units 1 and 2)", milestone: true, has_grade: true, Mock50: true)

# history_as_level2 = Subject.create!(
#   name: "History AS Level 2",
#   category: :as,
#   )

#   history_as_level2.topics.create!(name: "Topic 3.1: ‘Free at last’, 1865–77", time: 21, unit: "Unit 3: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)")
#   history_as_level2.topics.create!(name: "Topic 3.2: The triumph of ‘Jim Crow’, 1883– c1900", time: 22, unit: "Unit 3: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)")
#   history_as_level2.topics.create!(name: "Topic 3.3: Roosevelt and race Relations, 1933–45", time: 21, unit: "Unit 3: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)")
#   history_as_level2.topics.create!(name: "Topic 3.4: ‘I have a dream’, 1954–68", time: 22, unit: "Unit 3: Thematic Study with Source Evaluation : Civil Rights and Race Relations in USA (1865-2005)")
#   history_as_level2.topics.create!(name: "Topic 3.5: Race relations and Obama’s campaign for the presidency, c2000–09", time: 23.5, unit: "Unit 3: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)")
#   history_as_level2.topics.create!(name: "Unit 3 Assessment: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)", time: 1, unit: "Unit 3: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)", milestone: true, has_grade: true)
#   history_as_level2.topics.create!(name: "Topic 4.1: Historical interpretations: what explains the outbreak, course and impact of the Korean War in the period 1950–53?", time: 21, unit: "Unit 4: International Study with Historical Interpretations: Option 1D: The Cold War and Hot War in Asia (1945-90)")
#   history_as_level2.topics.create!(name: "Topic 4.2: The emergence of the Cold War in Southeast Asia, 1945–60", time: 20, unit: "Unit 4: International Study with Historical Interpretations: Option 1D: The Cold War and Hot War in Asia (1945-90)")
#   history_as_level2.topics.create!(name: "Topic 4.3: War in Indo-China, 1960–73", time: 20, unit: "Unit 4: International Study with Historical Interpretations: Option 1D: The Cold War and Hot War in Asia (1945-90)")
#   history_as_level2.topics.create!(name: "Topic 4.4: South-East Asia without the West: the fading of the Cold War, 1973–90", time: 21.5, unit: "Unit 4: International Study with Historical Interpretations: Option 1D: The Cold War and Hot War in Asia (1945-90)")
#   history_as_level2.topics.create!(name: "Unit 4 Assessment:  International Study with Historical Interpretations: Option 1D: The Cold War and Hot War in Asia (1945-90)", time: 1, unit: "Unit 4: International Study with Historical Interpretations: Option 1D: The Cold War and Hot War in Asia (1945-90)", milestone: true, has_grade: true)
#   history_as_level2.topics.create!(name: "100% Mock Exam  - Comprising of Units 3 and 4", time: 2, unit: "100% Mock Exam  - Comprising of Units 3 and 4", milestone: true, has_grade: true, Mock100: true)

# geography_a_level = Subject.create!(
#   name: "Geography A Level",
#   category: :al,
#   )

# geography_a_level.topics.create!(name: "Getting Started", time: 3, unit: "Getting Started")
# geography_a_level.topics.create!(name: "Topic 1.1 - The Hydrological System", time: 3, unit: "Unit 1 - Hydrology and Fluvial Geography")
# geography_a_level.topics.create!(name: "Topic 1.2 - The Drainage Basin System", time: 3, unit: "Unit 1 - Hydrology and Fluvial Geography")
# geography_a_level.topics.create!(name: "Topic 1.3 - Discharge Relationships Within Drainage Basins", time: 3, unit: "Unit 1 - Hydrology and Fluvial Geography")
# geography_a_level.topics.create!(name: "Topic 1.4 - River Channel Processes and Landforms", time: 3, unit: "Unit 1 - Hydrology and Fluvial Geography")
# geography_a_level.topics.create!(name: "Topic 1.5 - The Human Impact", time: 3, unit: "Unit 1 - Hydrology and Fluvial Geography")
# geography_a_level.topics.create!(name: "Topic 1.6 - Flooding Case Study: Ahr Valley, Germany and Belgium", time: 5, unit: "Unit 1 - Hydrology and Fluvial Geography")
# geography_a_level.topics.create!(name: "Unit 1 Assessment: Exam Preparation", time: 10, unit: "Unit 1 - Hydrology and Fluvial Geography")
# geography_a_level.topics.create!(name: "Topic 2.1 - Diurnal Energy Budgets", time: 3, unit: "Unit 2 - Atmosphere and Weather")
# geography_a_level.topics.create!(name: "Topic 2.2 - The Global Energy Budget", time: 3, unit: "Unit 2 - Atmosphere and Weather")
# geography_a_level.topics.create!(name: "Topic 2.3 - Weather Processes and Phenomena", time: 3, unit: "Unit 2 - Atmosphere and Weather")
# geography_a_level.topics.create!(name: "Topic 2.4 - The Human Impact on the Atmosphere and Weather", time: 3, unit: "Unit 2 - Atmosphere and Weather")
# geography_a_level.topics.create!(name: "Topic 2.5 - Case Study: Urban Microclimates (Heat Islands)", time: 4, unit: "Unit 2 - Atmosphere and Weather")
# geography_a_level.topics.create!(name: "Unit 2 Assessment: Exam Preparation", time: 10, unit: "Unit 2 - Atmosphere and Weather")
# geography_a_level.topics.create!(name: "Topic 3.1 - Plate Tectonics", time: 3, unit: "Unit 3 - Rocks and Weathering")
# geography_a_level.topics.create!(name: "Topic 3.2 - Weathering", time: 3, unit: "Unit 3 - Rocks and Weathering")
# geography_a_level.topics.create!(name: "Topic 3.3 - Slope Processes", time: 3, unit: "Unit 3 - Rocks and Weathering")
# geography_a_level.topics.create!(name: "Topic 3.4 - The Human Impact on Rocks and Weathering", time: 3, unit: "Unit 3 - Rocks and Weathering")
# geography_a_level.topics.create!(name: "Topic 3.5 - Case Study: Coastal Landslide in Alta County, Norway", time: 5, unit: "Unit 3 - Rocks and Weathering")
# geography_a_level.topics.create!(name: "Unit 3 Assessment: Exam Preparation", time: 10, unit: "Unit 3 - Rocks and Weathering")
# geography_a_level.topics.create!(name: "Topic 4.1 - Population Change", time: 3, unit: "Unit 4 - Population")
# geography_a_level.topics.create!(name: "Topic 4.2 - Demographic Transition", time: 3, unit: "Unit 4 - Population")
# geography_a_level.topics.create!(name: "Topic 4.3 - Population-resource relationships", time: 3, unit: "Unit 4 - Population")
# geography_a_level.topics.create!(name: "Topic 4.4 - The Management of Natural Increase CASE STUDY", time: 5, unit: "Unit 4 - Population")
# geography_a_level.topics.create!(name: "Unit 4 Assessment: Exam Preparation", time: 10, unit: "Unit 4 - Population")
# geography_a_level.topics.create!(name: "Topic 5.1 - Migration as a Component of Population Change", time: 3, unit: "Unit 5 - Migration")
# geography_a_level.topics.create!(name: "Topic 5.2 - Internal Migration", time: 3, unit: "Unit 5 - Migration")
# geography_a_level.topics.create!(name: "Topic 5.3 - International Migration", time: 3, unit: "Unit 5 - Migration")
# geography_a_level.topics.create!(name: "Topic 5.4 - The Management of International Migration", time: 3, unit: "Unit 5 - Migration")
# geography_a_level.topics.create!(name: "Unit 5 Assessment: Exam Preparation", time: 10, unit: "Unit 5 - Migration")
# geography_a_level.topics.create!(name: "Topic 6.1 - Changes in Rural Settlements", time: 3, unit: "Unit 6 - Settlement Dynamics")
# geography_a_level.topics.create!(name: "Topic 6.2 - Urban Trends and Issues of Urbanisation", time: 3, unit: "Unit 6 - Settlement Dynamics")
# geography_a_level.topics.create!(name: "Topic 6.3 - The Changing Structure of Urban Settlements", time: 3, unit: "Unit 6 - Settlement Dynamics")
# geography_a_level.topics.create!(name: "Topic 6.4 - The Management of Urban Settlements - CASE STUDY", time: 5, unit: "Unit 6 - Settlement Dynamics")
# geography_a_level.topics.create!(name: "Unit 6 Assessment: Exam Preparation", time: 10, unit: "Unit 6 - Settlement Dynamics")
# geography_a_level.topics.create!(name: "Mock 50%", time: 3, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
# geography_a_level.topics.create!(name: "Topic 7.1 - Coastal Processes", time: 3, unit: "Unit 7 - Coastal Environments")
# geography_a_level.topics.create!(name: "Topic 7.2 - Sediment Budgets and Erosion", time: 3, unit: "Unit 7 - Coastal Environments")
# geography_a_level.topics.create!(name: "Topic 7.3 -Characteristics and Formation of Coastal Landforms", time: 3, unit: "Unit 7 - Coastal Environments")
# geography_a_level.topics.create!(name: "Topic 7.4 -Coral Reefs", time: 5, unit: "Unit 7 - Coastal Environments")
# geography_a_level.topics.create!(name: "Topic 7.5 - Sustainable Management of Coasts", time: 3, unit: "Unit 7 - Coastal Environments")
# geography_a_level.topics.create!(name: "Topic 7.6 -CASE STUDY: The Battle Against the Sea", time: 3, unit: "Unit 7 - Coastal Environments")
# geography_a_level.topics.create!(name: "Unit 7 Assessment: Exam Preparation", time: 10, unit: "Unit 7 - Coastal Environments")
# geography_a_level.topics.create!(name: "Topic 8.1 - Hazards Resulting from Tectonic Processes", time: 3, unit: "Unit 8 - Hazardous Environments")
# geography_a_level.topics.create!(name: "Topic 8.2 - Hazards Resulting from Tectonic Processes Case Study (Haiti)", time: 5, unit: "Unit 8 - Hazardous Environments")
# geography_a_level.topics.create!(name: "Topic 8.3 - Hazards Resulting from Mass Movements", time: 3, unit: "Unit 8 - Hazardous Environments")
# geography_a_level.topics.create!(name: "Topic 8.4 - Hazards Resulting from Mass Movements (Case Study)", time: 5, unit: "Unit 8 - Hazardous Environments")
# geography_a_level.topics.create!(name: "Topic 8.5 - Hazards Resulting from Atmospheric Disturbances", time: 3, unit: "Unit 8 - Hazardous Environments")
# geography_a_level.topics.create!(name: "Topic 8.6 - Hazards Resulting from Atmospheric Disturbances (Case Study)", time: 5, unit: "Unit 8 - Hazardous Environments")
# geography_a_level.topics.create!(name: "Topic 8.7 - Sustainable Management in Hazardous Environments (Case Study)", time: 5, unit: "Unit 8 - Hazardous Environments")
# geography_a_level.topics.create!(name: "Unit 8 Assessment: Exam Preparation", time: 10, unit: "Unit 8 - Hazardous Environments")
# geography_a_level.topics.create!(name: "Topic 9.1 - Agricultural Systems and Food Production", time: 3, unit: "Unit 9 - Production, Location, and Change")
# geography_a_level.topics.create!(name: "Topic 9.2 - The Management of Agricultural Change CASE STUDY", time: 5, unit: "Unit 9 - Production, Location, and Change")
# geography_a_level.topics.create!(name: "Topic 9.3 - Manufacturing and Related Service Industry", time: 3, unit: "Unit 9 - Production, Location, and Change")
# geography_a_level.topics.create!(name: "Topic 9.4 - The Management of Manufacturing Change CASE STUDY", time: 5, unit: "Unit 9 - Production, Location, and Change")
# geography_a_level.topics.create!(name: "Unit 9 Assessment: Exam Preparation", time: 3, unit: "Unit 9 - Production, Location, and Change")
# geography_a_level.topics.create!(name: "Topic 10.1 - Sustainable Energy Supplies", time: 3, unit: "Unit 10 - Environmental Management")
# geography_a_level.topics.create!(name: "Topic 10.2 - The Management of Energy Supply CASE STUDY", time: 3, unit: "Unit 10 - Environmental Management")
# geography_a_level.topics.create!(name: "Topic 10.3 - Environmental Degradation", time: 5, unit: "Unit 10 - Environmental Management")
# geography_a_level.topics.create!(name: "Topic 10.4 - The Management of Degraded Environments CASE STUDY", time: 10, unit: "Unit 10 - Environmental Management")
# geography_a_level.topics.create!(name: "Unit 10 Assessment: Exam Preparation", time: 10, unit: "Unit 10 - Environmental Management")
# geography_a_level.topics.create!(name: "Mock 100%", time: 3, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

# geography_as_level1 = Subject.create!(
#   name: "Geography AS Level 1",
#   category: :as,
#   )

#   geography_as_level1.topics.create!(name: "Getting Started", time: 3, unit: "Getting Started")
#   geography_as_level1.topics.create!(name: "Topic 1.1 - The Hydrological System", time: 3, unit: "Unit 1 - Hydrology and Fluvial Geography")
#   geography_as_level1.topics.create!(name: "Topic 1.2 - The Drainage Basin System", time: 3, unit: "Unit 1 - Hydrology and Fluvial Geography")
#   geography_as_level1.topics.create!(name: "Topic 1.3 - Discharge Relationships Within Drainage Basins", time: 3, unit: "Unit 1 - Hydrology and Fluvial Geography")
#   geography_as_level1.topics.create!(name: "Topic 1.4 - River Channel Processes and Landforms", time: 3, unit: "Unit 1 - Hydrology and Fluvial Geography")
#   geography_as_level1.topics.create!(name: "Topic 1.5 - The Human Impact", time: 3, unit: "Unit 1 - Hydrology and Fluvial Geography")
#   geography_as_level1.topics.create!(name: "Topic 1.6 - Flooding Case Study: Ahr Valley, Germany and Belgium", time: 5, unit: "Unit 1 - Hydrology and Fluvial Geography")
#   geography_as_level1.topics.create!(name: "Unit 1 Assessment: Exam Preparation", time: 10, unit: "Unit 1 - Hydrology and Fluvial Geography", milestone: true, has_grade: true)
#   geography_as_level1.topics.create!(name: "Topic 2.1 - Diurnal Energy Budgets", time: 3, unit: "Unit 2 - Atmosphere and Weather")
#   geography_as_level1.topics.create!(name: "Topic 2.2 - The Global Energy Budget", time: 3, unit: "Unit 2 - Atmosphere and Weather")
#   geography_as_level1.topics.create!(name: "Topic 2.3 - Weather Processes and Phenomena", time: 3, unit: "Unit 2 - Atmosphere and Weather")
#   geography_as_level1.topics.create!(name: "Topic 2.4 - The Human Impact on the Atmosphere and Weather", time: 3, unit: "Unit 2 - Atmosphere and Weather")
#   geography_as_level1.topics.create!(name: "Topic 2.5 - Case Study: Urban Microclimates (Heat Islands)", time: 4, unit: "Unit 2 - Atmosphere and Weather")
#   geography_as_level1.topics.create!(name: "Unit 2 Assessment: Exam Preparation", time: 10, unit: "Unit 2 - Atmosphere and Weather", milestone: true, has_grade: true)
#   geography_as_level1.topics.create!(name: "Topic 3.1 - Plate Tectonics", time: 3, unit: "Unit 3 - Rocks and Weathering")
#   geography_as_level1.topics.create!(name: "Topic 3.2 - Weathering", time: 3, unit: "Unit 3 - Rocks and Weathering")
#   geography_as_level1.topics.create!(name: "Topic 3.3 - Slope Processes", time: 3, unit: "Unit 3 - Rocks and Weathering")
#   geography_as_level1.topics.create!(name: "Topic 3.4 - The Human Impact on Rocks and Weathering", time: 3, unit: "Unit 3 - Rocks and Weathering")
#   geography_as_level1.topics.create!(name: "Topic 3.5 - Case Study: Coastal Landslide in Alta County, Norway", time: 5, unit: "Unit 3 - Rocks and Weathering")
#   geography_as_level1.topics.create!(name: "Unit 3 Assessment: Exam Preparation", time: 10, unit: "Unit 3 - Rocks and Weathering", milestone: true, has_grade: true)
#   geography_as_level1.topics.create!(name: "Topic 4.1 - Population Change", time: 3, unit: "Unit 4 - Population")
#   geography_as_level1.topics.create!(name: "Topic 4.2 - Demographic Transition", time: 3, unit: "Unit 4 - Population")
#   geography_as_level1.topics.create!(name: "Topic 4.3 - Population-resource relationships", time: 3, unit: "Unit 4 - Population")
#   geography_as_level1.topics.create!(name: "Topic 4.4 - The Management of Natural Increase CASE STUDY", time: 5, unit: "Unit 4 - Population")
#   geography_as_level1.topics.create!(name: "Unit 4 Assessment: Exam Preparation", time: 10, unit: "Unit 4 - Population", milestone: true, has_grade: true)
#   geography_as_level1.topics.create!(name: "Topic 5.1 - Migration as a Component of Population Change", time: 3, unit: "Unit 5 - Migration")
#   geography_as_level1.topics.create!(name: "Topic 5.2 - Internal Migration", time: 3, unit: "Unit 5 - Migration")
#   geography_as_level1.topics.create!(name: "Topic 5.3 - International Migration", time: 3, unit: "Unit 5 - Migration")
#   geography_as_level1.topics.create!(name: "Topic 5.4 - The Management of International Migration", time: 3, unit: "Unit 5 - Migration")
#   geography_as_level1.topics.create!(name: "Unit 5 Assessment: Exam Preparation", time: 10, unit: "Unit 5 - Migration", milestone: true, has_grade: true)
#   geography_as_level1.topics.create!(name: "Topic 6.1 - Changes in Rural Settlements", time: 3, unit: "Unit 6 - Settlement Dynamics")
#   geography_as_level1.topics.create!(name: "Topic 6.2 - Urban Trends and Issues of Urbanisation", time: 3, unit: "Unit 6 - Settlement Dynamics")
#   geography_as_level1.topics.create!(name: "Topic 6.3 - The Changing Structure of Urban Settlements", time: 3, unit: "Unit 6 - Settlement Dynamics")
#   geography_as_level1.topics.create!(name: "Topic 6.4 - The Management of Urban Settlements - CASE STUDY", time: 5, unit: "Unit 6 - Settlement Dynamics")
#   geography_as_level1.topics.create!(name: "Unit 6 Assessment: Exam Preparation", time: 10, unit: "Unit 6 - Settlement Dynamics", milestone: true, has_grade: true)
#   geography_as_level1.topics.create!(name: "Mock 50%", time: 3, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)

# geography_as_level2 = Subject.create!(
#   name: "Geography AS Level 2",
#   category: :as,
#   )

#   geography_as_level2.topics.create!(name: "Topic 7.1 - Coastal Processes", time: 3, unit: "Unit 7 - Coastal Environments")
#   geography_as_level2.topics.create!(name: "Topic 7.2 - Sediment Budgets and Erosion", time: 3, unit: "Unit 7 - Coastal Environments")
#   geography_as_level2.topics.create!(name: "Topic 7.3 - Characteristics and Formation of Coastal Landforms", time: 3, unit: "Unit 7 - Coastal Environments")
#   geography_as_level2.topics.create!(name: "Topic 7.4 - Coral Reefs", time: 5, unit: "Unit 7 - Coastal Environments")
#   geography_as_level2.topics.create!(name: "Topic 7.5 - Sustainable Management of Coasts", time: 3, unit: "Unit 7 - Coastal Environments")
#   geography_as_level2.topics.create!(name: "Topic 7.6 - CASE STUDY: The Battle Against the Sea", time: 3, unit: "Unit 7 - Coastal Environments")
#   geography_as_level2.topics.create!(name: "Unit 7 Assessment: Exam Preparation", time: 10, unit: "Unit 7 - Coastal Environments", milestone: true, has_grade: true)
#   geography_as_level2.topics.create!(name: "Topic 8.1 - Hazards Resulting from Tectonic Processes", time: 3, unit: "Unit 8 - Hazardous Environments")
#   geography_as_level2.topics.create!(name: "Topic 8.2 - Hazards Resulting from Tectonic Processes Case Study (Haiti)", time: 5, unit: "Unit 8 - Hazardous Environments")
#   geography_as_level2.topics.create!(name: "Topic 8.3 - Hazards Resulting from Mass Movements", time: 3, unit: "Unit 8 - Hazardous Environments")
#   geography_as_level2.topics.create!(name: "Topic 8.4 - Hazards Resulting from Mass Movements (Case Study)", time: 5, unit: "Unit 8 - Hazardous Environments")
#   geography_as_level2.topics.create!(name: "Topic 8.5 - Hazards Resulting from Atmospheric Disturbances", time: 3, unit: "Unit 8 - Hazardous Environments")
#   geography_as_level2.topics.create!(name: "Topic 8.6 - Hazards Resulting from Atmospheric Disturbances (Case Study)", time: 5, unit: "Unit 8 - Hazardous Environments")
#   geography_as_level2.topics.create!(name: "Topic 8.7 - Sustainable Management in Hazardous Environments (Case Study)", time: 5, unit: "Unit 8 - Hazardous Environments")
#   geography_as_level2.topics.create!(name: "Unit 8 Assessment: Exam Preparation", time: 10, unit: "Unit 8 - Hazardous Environments", milestone: true, has_grade: true)
#   geography_as_level2.topics.create!(name: "Topic 9.1 - Agricultural Systems and Food Production", time: 3, unit: "Unit 9 - Production, Location, and Change")
#   geography_as_level2.topics.create!(name: "Topic 9.2 - The Management of Agricultural Change CASE STUDY", time: 5, unit: "Unit 9 - Production, Location, and Change")
#   geography_as_level2.topics.create!(name: "Topic 9.3 - Manufacturing and Related Service Industry", time: 3, unit: "Unit 9 - Production, Location, and Change")
#   geography_as_level2.topics.create!(name: "Topic 9.4 - The Management of Manufacturing Change CASE STUDY", time: 5, unit: "Unit 9 - Production, Location, and Change")
#   geography_as_level2.topics.create!(name: "Unit 9 Assessment: Exam Preparation", time: 3, unit: "Unit 9 - Production, Location, and Change", milestone: true, has_grade: true)
#   geography_as_level2.topics.create!(name: "Topic 10.1 - Sustainable Energy Supplies", time: 3, unit: "Unit 10 - Environmental Management")
#   geography_as_level2.topics.create!(name: "Topic 10.2 - The Management of Energy Supply CASE STUDY", time: 3, unit: "Unit 10 - Environmental Management")
#   geography_as_level2.topics.create!(name: "Topic 10.3 - Environmental Degradation", time: 5, unit: "Unit 10 - Environmental Management")
#   geography_as_level2.topics.create!(name: "Topic 10.4 - The Management of Degraded Environments CASE STUDY", time: 10, unit: "Unit 10 - Environmental Management")
#   geography_as_level2.topics.create!(name: "Unit 10 Assessment: Exam Preparation", time: 10, unit: "Unit 10 - Environmental Management", milestone: true, has_grade: true)
#   geography_as_level2.topics.create!(name: "Mock 100%", time: 3, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

# english_a_level = Subject.create!(
#   name: "English A Level",
#   category: :al,
#   )

# english_a_level.topics.create!(name: "Topic 1: Word Classes", time: 6, unit: "Unit 1 Linguistic Features")
# english_a_level.topics.create!(name: "Topic 2: Syntax", time: 6, unit: "Unit 1 Linguistic Features")
# english_a_level.topics.create!(name: "Topic 3: Lexis", time: 8, unit: "Unit 1 Linguistic Features")
# english_a_level.topics.create!(name: "Topic 4: Tone and Tonal Shifts", time: 5, unit: "Unit 1 Linguistic Features")
# english_a_level.topics.create!(name: "Topic 5: Phonology", time: 8, unit: "Unit 1 Linguistic Features")
# english_a_level.topics.create!(name: "Topic 1 - Figurative Language", time: 5, unit: "Unit 2 - Literary Features")
# english_a_level.topics.create!(name: "Topic 2 - Image and Symbols", time: 7, unit: "Unit 2 - Literary Features")
# english_a_level.topics.create!(name: "Topic 3 - Narrative Features", time: 7, unit: "Unit 2 - Literary Features")
# english_a_level.topics.create!(name: "Topic 4 - Literary Genre - Tragedy", time: 4, unit: "Unit 2 - Literary Features")
# english_a_level.topics.create!(name: "Topic 5 - Other Literary Genres", time: 9, unit: "Unit 2 - Literary Features")
# english_a_level.topics.create!(name: "Topic 1 - Context of Production", time: 5, unit: "Unit 3: A Streetcar Named Desire")
# english_a_level.topics.create!(name: "Topic 2 - Exposition Scenes", time: 7, unit: "Unit 3: A Streetcar Named Desire")
# english_a_level.topics.create!(name: "Topic 3 - The Rising Action", time: 7, unit: "Unit 3: A Streetcar Named Desire")
# english_a_level.topics.create!(name: "Topic 4 - Climax and Resolution", time: 6, unit: "Unit 3: A Streetcar Named Desire")
# english_a_level.topics.create!(name: "Topic 5 - Application of Knowledge", time: 11, unit: "Unit 3: A Streetcar Named Desire")
# english_a_level.topics.create!(name: "Topic 1 - Life Writing", time: 8, unit: "Unit 4. Genre Features (With synthesis of Topic 1 & 2)")
# english_a_level.topics.create!(name: "Topic 2 - Travel Writing & Reviews", time: 7, unit: "Unit 4. Genre Features (With synthesis of Topic 1 & 2)")
# english_a_level.topics.create!(name: "Topic 3 - Articles", time: 5, unit: "Unit 4. Genre Features (With synthesis of Topic 1 & 2)")
# english_a_level.topics.create!(name: "Topic 4 - Interview & Podcast", time: 5, unit: "Unit 4. Genre Features (With synthesis of Topic 1 & 2)")
# english_a_level.topics.create!(name: "Topic 5 - Writing for the Screen, Stage, Radio & Speeches", time: 11, unit: "Unit 4. Genre Features (With synthesis of Topic 1 & 2)")
# english_a_level.topics.create!(name: "Topic 5.1 NEA Proposal", time: 10, unit: "Unit 5: Non-examined Assessment")
# english_a_level.topics.create!(name: "Formal Coursework Proposal", time: 5, unit: "Unit 5: Non-examined Assessment")
# english_a_level.topics.create!(name: "Topic 5.2 Reading and Research", time: 5, unit: "Unit 5: Non-examined Assessment")
# english_a_level.topics.create!(name: "1st Draft Fiction Piece", time: 10, unit: "Unit 5: Non-examined Assessment")
# english_a_level.topics.create!(name: "1st Draft Non-Fiction Piece", time: 10, unit: "Unit 5: Non-examined Assessment")
# english_a_level.topics.create!(name: "1st Completed Portfolio", time: 15, unit: "Unit 5: Non-examined Assessment")
# english_a_level.topics.create!(name: "Reading Log Submission", time: 10, unit: "Unit 5: Non-examined Assessment")
# english_a_level.topics.create!(name: "Topic 1 - Cultural Context of Production", time: 10, unit: "Unit 6: A Room with a View")
# english_a_level.topics.create!(name: "Topic 2 - Exposition & Rising Action", time: 9, unit: "Unit 6: A Room with a View")
# english_a_level.topics.create!(name: "Topic 3 - Falling Action + Resolution", time: 8, unit: "Unit 6: A Room with a View")
# english_a_level.topics.create!(name: "Topic 4 - Setting, characters & themes", time: 10, unit: "Unit 6: A Room with a View")
# english_a_level.topics.create!(name: "Topic 5 - How to revise for Forster", time: 4, unit: "Unit 6: A Room with a View")
# english_a_level.topics.create!(name: "Topic 1: Context of Production", time: 7, unit: "Unit 7: The Bloody Chamber")
# english_a_level.topics.create!(name: "Topic 2: The Bloody Chamber & The Feline Stories", time: 10, unit: "Unit 7: The Bloody Chamber")
# english_a_level.topics.create!(name: "Topic 3: Fantasy Stories", time: 3, unit: "Unit 7: The Bloody Chamber")
# english_a_level.topics.create!(name: "Topic 4: Wolf Stories", time: 8, unit: "Unit 7: The Bloody Chamber")
# english_a_level.topics.create!(name: "Topic 5: Check your knowledge of the whole text", time: 4, unit: "Unit 7: The Bloody Chamber")
# english_a_level.topics.create!(name: "Topic 1: Paragraphing", time: 3, unit: "Unit 8: Exam Preparation")
# english_a_level.topics.create!(name: "Topic 2: How to annotate", time: 3, unit: "Unit 8: Exam Preparation")
# english_a_level.topics.create!(name: "Topic 3: How to analyse", time: 3, unit: "Unit 8: Exam Preparation")
# english_a_level.topics.create!(name: "Topic 4: Comparative analysis Paper 1", time: 3, unit: "Unit 8: Exam Preparation")
# english_a_level.topics.create!(name: "Topic 5: Comparative analysis Paper 2", time: 3, unit: "Unit 8: Exam Preparation")
# english_a_level.topics.create!(name: "Assessments", time: 23, unit: "Unit 8: Exam Preparation", milestone: true, has_grade: true)
# english_a_level.topics.create!(name: "Mock 100%", time: 3, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

# english_as_level1 = Subject.create!(
#   name: "English AS Level 1",
#   category: :as,
#   )

#   english_as_level1.topics.create!(name: "Topic 1: Word Classes", time: 6, unit: "Unit 1 Linguistic Features")
#   english_as_level1.topics.create!(name: "Topic 2: Syntax", time: 6, unit: "Unit 1 Linguistic Features")
#   english_as_level1.topics.create!(name: "Topic 3: Lexis", time: 8, unit: "Unit 1 Linguistic Features")
#   english_as_level1.topics.create!(name: "Topic 4: Tone and Tonal Shifts", time: 5, unit: "Unit 1 Linguistic Features")
#   english_as_level1.topics.create!(name: "Topic 5: Phonology", time: 8, unit: "Unit 1 Linguistic Features")
#   english_as_level1.topics.create!(name: "Topic 1 - Figurative Language", time: 5, unit: "Unit 2 - Literary Features")
#   english_as_level1.topics.create!(name: "Topic 2 - Image and Symbols", time: 7, unit: "Unit 2 - Literary Features")
#   english_as_level1.topics.create!(name: "Topic 3 - Narrative Features", time: 7, unit: "Unit 2 - Literary Features")
#   english_as_level1.topics.create!(name: "Topic 4 - Literary Genre - Tragedy", time: 4, unit: "Unit 2 - Literary Features")
#   english_as_level1.topics.create!(name: "Topic 5 - Other Literary Genres", time: 9, unit: "Unit 2 - Literary Features")
#   english_as_level1.topics.create!(name: "Topic 1 - Context of Production", time: 5, unit: "Unit 3: A Streetcar Named Desire")
#   english_as_level1.topics.create!(name: "Topic 2 - Exposition Scenes", time: 7, unit: "Unit 3: A Streetcar Named Desire")
#   english_as_level1.topics.create!(name: "Topic 3 - The Rising Action", time: 7, unit: "Unit 3: A Streetcar Named Desire")
#   english_as_level1.topics.create!(name: "Topic 4 - Climax and Resolution", time: 6, unit: "Unit 3: A Streetcar Named Desire")
#   english_as_level1.topics.create!(name: "Topic 5 - Application of Knowledge", time: 11, unit: "Unit 3: A Streetcar Named Desire")
#   english_as_level1.topics.create!(name: "Topic 1 - Life Writing", time: 8, unit: "Unit 4. Genre Features (With synthesis of Topic 1 & 2)")
#   english_as_level1.topics.create!(name: "Topic 2 - Travel Writing & Reviews", time: 7, unit: "Unit 4. Genre Features (With synthesis of Topic 1 & 2)")
#   english_as_level1.topics.create!(name: "Topic 3 - Articles", time: 5, unit: "Unit 4. Genre Features (With synthesis of Topic 1 & 2)")
#   english_as_level1.topics.create!(name: "Topic 4 - Interview & Podcast", time: 5, unit: "Unit 4. Genre Features (With synthesis of Topic 1 & 2)")
#   english_as_level1.topics.create!(name: "Topic 5 - Writing for the Screen, Stage, Radio & Speeches", time: 11, unit: "Unit 4. Genre Features (With synthesis of Topic 1 & 2)")
#   english_as_level1.topics.create!(name: "Mock 50%", time: 5, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)

# english_as_level2 = Subject.create!(
#   name: "English AS Level 2",
#   category: :as,
#   )

#   english_as_level2.topics.create!(name: "Topic 5.1 NEA Proposal", time: 10, unit: "Unit 5: Non-examined Assessment")
#   english_as_level2.topics.create!(name: "Formal Coursework Proposal", time: 5, unit: "Unit 5: Non-examined Assessment")
#   english_as_level2.topics.create!(name: "Topic 5.2 Reading and Research", time: 5, unit: "Unit 5: Non-examined Assessment")
#   english_as_level2.topics.create!(name: "1st Draft Fiction Piece", time: 10, unit: "Unit 5: Non-examined Assessment")
#   english_as_level2.topics.create!(name: "1st Draft Non-Fiction Piece", time: 10, unit: "Unit 5: Non-examined Assessment")
#   english_as_level2.topics.create!(name: "1st Completed Portfolio", time: 15, unit: "Unit 5: Non-examined Assessment")
#   english_as_level2.topics.create!(name: "Reading Log Submission", time: 10, unit: "Unit 5: Non-examined Assessment")
#   english_as_level2.topics.create!(name: "Topic 1 - Cultural Context of Production", time: 10, unit: "Unit 6: A Room with a View")
#   english_as_level2.topics.create!(name: "Topic 2 - Exposition & Rising Action", time: 9, unit: "Unit 6: A Room with a View")
#   english_as_level2.topics.create!(name: "Topic 3 - Falling Action + Resolution", time: 8, unit: "Unit 6: A Room with a View")
#   english_as_level2.topics.create!(name: "Topic 4 - Setting, characters & themes", time: 10, unit: "Unit 6: A Room with a View")
#   english_as_level2.topics.create!(name: "Topic 5 - How to revise for Forster", time: 4, unit: "Unit 6: A Room with a View")
#   english_as_level2.topics.create!(name: "Topic 1: Context of Production", time: 7, unit: "Unit 7: The Bloody Chamber")
#   english_as_level2.topics.create!(name: "Topic 2: The Bloody Chamber & The Feline Stories", time: 10, unit: "Unit 7: The Bloody Chamber")
#   english_as_level2.topics.create!(name: "Topic 3: Fantasy Stories", time: 3, unit: "Unit 7: The Bloody Chamber")
#   english_as_level2.topics.create!(name: "Topic 4: Wolf Stories", time: 8, unit: "Unit 7: The Bloody Chamber")
#   english_as_level2.topics.create!(name: "Topic 5: Check your knowledge of the whole text", time: 4, unit: "Unit 7: The Bloody Chamber")
#   english_as_level2.topics.create!(name: "Topic 1: Paragraphing", time: 3, unit: "Unit 8: Exam Preparation")
#   english_as_level2.topics.create!(name: "Topic 2: How to annotate", time: 3, unit: "Unit 8: Exam Preparation")
#   english_as_level2.topics.create!(name: "Topic 3: How to analyse", time: 3, unit: "Unit 8: Exam Preparation")
#   english_as_level2.topics.create!(name: "Topic 4: Comparative analysis Paper 1", time: 3, unit: "Unit 8: Exam Preparation")
#   english_as_level2.topics.create!(name: "Topic 5: Comparative analysis Paper 2", time: 3, unit: "Unit 8: Exam Preparation")
#   english_as_level2.topics.create!(name: "Assessments", time: 23, unit: "Unit 8: Exam Preparation", milestone: true, has_grade: true)
#   english_as_level2.topics.create!(name: "Mock 100%", time: 3, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)


# env_management_as_level1 = Subject.create!(
#   name: "Env Management AS Level 1",
#   category: :as,
#   )

#   env_management_as_level1.topics.create!(name: "Topic 1.1 - Introduction to Environmental Management", time: 10, unit: "Unit 1: Introduction to Environmental Management")
#   env_management_as_level1.topics.create!(name: "Topic 1.2 - Environmental Systems", time: 16, unit: "Unit 1: Introduction to Environmental Management")
#   env_management_as_level1.topics.create!(name: "Unit 1 Assessment (Warm up mock exam)", time: 2, unit: "Unit 1: Introduction to Environmental Management", milestone: true, has_grade: true)
#   env_management_as_level1.topics.create!(name: "Topic 2.1 - Environmental Research", time: 8, unit: "Unit 2: Environmental Research and Data Collection")
#   env_management_as_level1.topics.create!(name: "Topic 2.2 - Data Collection and Analysis", time: 16, unit: "Unit 2: Environmental Research and Data Collection")
#   env_management_as_level1.topics.create!(name: "Unit 2 Assessment (Warm up mock exam)", time: 2, unit: "Unit 2: Environmental Research and Data Collection", milestone: true, has_grade: true)
#   env_management_as_level1.topics.create!(name: "Topic 3.1 - Human Population Dynamics", time: 4, unit: "Unit 3: Managing Human Population")
#   env_management_as_level1.topics.create!(name: "Topic 3.2 - Population Change", time: 10, unit: "Unit 3: Managing Human Population")
#   env_management_as_level1.topics.create!(name: "Unit 3 Assessment (Warm up mock exam)", time: 2, unit: "Unit 3: Managing Human Population", milestone: true, has_grade: true)
#   env_management_as_level1.topics.create!(name: "Topic 4.1 - Ecosystems and Biodiversity", time: 10, unit: "Unit 4: Managing Ecosystems and Biodiversity")
#   env_management_as_level1.topics.create!(name: "Topic 4.2 - Impact of Human Activity on Ecosystems", time: 10, unit: "Unit 4: Managing Ecosystems and Biodiversity")
#   env_management_as_level1.topics.create!(name: "Unit 4 Assessment (Warm up mock exam)", time: 2, unit: "Unit 4: Managing Ecosystems and Biodiversity", milestone: true, has_grade: true)
#   env_management_as_level1.topics.create!(name: "Topic 5.1 - Food and Energy", time: 10, unit: "Unit 5: Managing Resources")
#   env_management_as_level1.topics.create!(name: "Topic 5.2 - Water and Waste", time: 10, unit: "Unit 5: Managing Resources")
#   env_management_as_level1.topics.create!(name: "Unit 5 Assessment (Warm up mock exam)", time: 2, unit: "Unit 5: Managing Resources", milestone: true, has_grade: true)
#   env_management_as_level1.topics.create!(name: "Topic 6.1 - Air Pollution", time: 12, unit: "Unit 6: The Atmosphere and Climate Change")
#   env_management_as_level1.topics.create!(name: "Topic 6.2 - The Impacts and Management of Climate Change", time: 6, unit: "Unit 6: The Atmosphere and Climate Change")
#   env_management_as_level1.topics.create!(name: "Unit 6 Assessment (Warm up mock exam)", time: 2, unit: "Unit 6: The Atmosphere and Climate Change", milestone: true, has_grade: true)
#   env_management_as_level1.topics.create!(name: "Exam preparation and revision - 50% Mock Exam", time: 20, unit: "Exam preparation and revision - 50% Mock Exam", milestone: true, has_grade: true, Mock50: true)




# maths_igcse = Subject.create!(
#   name: "Mathematics IGCSE",
#   category: :igcse,
#   )

#   maths_igcse.topics.create!(name: "Introduction", time: 1, unit: "Introduction")
#   maths_igcse.topics.create!(name: "Topic 1.1: Integers", time: 2.5, unit: "Unit 1: Numbers")
#   maths_igcse.topics.create!(name: "Topic 1.2: Basic Arithmetic", time: 2.5, unit: "Unit 1: Numbers")
#   maths_igcse.topics.create!(name: "Topic 1.3: Decimals", time: 3, unit: "Unit 1: Numbers")
#   maths_igcse.topics.create!(name: "Topic 1.4: Fractions", time: 5, unit: "Unit 1: Numbers")
#   maths_igcse.topics.create!(name: "Topic 1.5: Powers and Roots", time: 6, unit: "Unit 1: Numbers")
#   maths_igcse.topics.create!(name: "Topic 1.6: Finding HCF and LCM", time: 5, unit: "Unit 1: Numbers")
#   maths_igcse.topics.create!(name: "Topic 1.7: Set Notation", time: 6, unit: "Unit 1: Numbers")
#   maths_igcse.topics.create!(name: "Topic 1.8: Percentages", time: 8, unit: "Unit 1: Numbers")
#   maths_igcse.topics.create!(name: "Topic 1.9: Ratio and Proportion", time: 5, unit: "Unit 1: Numbers")
#   maths_igcse.topics.create!(name: "Topic 1.10: Degrees of Accuracy", time: 4, unit: "Unit 1: Numbers")
#   maths_igcse.topics.create!(name: "Topic 1.11: Standard Form", time: 4, unit: "Unit 1: Numbers")
#   maths_igcse.topics.create!(name: "Cross-Topic Review (Unit 1 Numbers)", time: 13, unit: "Unit 1: Numbers")
#   maths_igcse.topics.create!(name: "Master Assessments", time: 3, unit: "Unit 1: Numbers", milestone: true, has_grade: true)
#   maths_igcse.topics.create!(name: "Topic 2.1: Electronic Calculators", time: 3, unit: "Unit 2: Algebra")
#   maths_igcse.topics.create!(name: "Topic 2.2: Equations Formula and Identities", time: 3, unit: "Unit 2: Algebra")
#   maths_igcse.topics.create!(name: "Topic 2.3: Rearranging Expressions and Formulae", time: 5, unit: "Unit 2: Algebra")
#   maths_igcse.topics.create!(name: "Topic 2.4: Algebraic Manipulation", time: 6, unit: "Unit 2: Algebra")
#   maths_igcse.topics.create!(name: "Topic 2.5: Algebraic Methods", time: 7, unit: "Unit 2: Algebra")
#   maths_igcse.topics.create!(name: "Topic 2.6: Linear Equations", time: 6, unit: "Unit 2: Algebra")
#   maths_igcse.topics.create!(name: "Topic 2.7: Graphs", time: 17, unit: "Unit 2: Algebra")
#   maths_igcse.topics.create!(name: "Topic 2.8: Proportion", time: 4, unit: "Unit 2: Algebra")
#   maths_igcse.topics.create!(name: "Topic 2.9: Simultaneous Equations", time: 7, unit: "Unit 2: Algebra")
#   maths_igcse.topics.create!(name: "Topic 2.10: Quadratic Equations", time: 14, unit: "Unit 2: Algebra")
#   maths_igcse.topics.create!(name: "Topic 2.11: Inequalities", time: 5, unit: "Unit 2: Algebra")
#   maths_igcse.topics.create!(name: "Topic 2.12: Function Notation", time: 14, unit: "Unit 2: Algebra")
#   maths_igcse.topics.create!(name: "Topic 2.13: Sequences", time: 6, unit: "Unit 2: Algebra")
#   maths_igcse.topics.create!(name: "Topic 2.14: Further Graphs", time: 11, unit: "Unit 2: Algebra")
#   maths_igcse.topics.create!(name: "Topic 2.15: Calculus", time: 15, unit: "Unit 2: Algebra")
#   maths_igcse.topics.create!(name: "Cross-Topic Review (Unit 2 Algebra)", time: 15, unit: "Unit 2: Algebra")
#   maths_igcse.topics.create!(name: "Master Assessments", time: 3, unit: "Unit 2: Algebra", milestone: true, has_grade: true)
#   maths_igcse.topics.create!(name: "Mock Exam 50%", time: 2, unit: "Mock Exam 50%", milestone: true, has_grade: true, Mock50: true)
#   maths_igcse.topics.create!(name: "Topic 3.1: Angles and Lines", time: 4, unit: "Unit 3: Geometry")
#   maths_igcse.topics.create!(name: "Topic 3.2: Polygons and Triangles", time: 4, unit: "Unit 3: Geometry")
#   maths_igcse.topics.create!(name: "Topic 3.3: Symmetry", time: 4, unit: "Unit 3: Geometry")
#   maths_igcse.topics.create!(name: "Topic 3.4: Time and Measurements", time: 4, unit: "Unit 3: Geometry")
#   maths_igcse.topics.create!(name: "Topic 3.5: Circles", time: 7, unit: "Unit 3: Geometry")
#   maths_igcse.topics.create!(name: "Topic 3.6: Pythagoras Trigonometry", time: 6, unit: "Unit 3: Geometry")
#   maths_igcse.topics.create!(name: "Topic 3.7: 3D Shapes Volume", time: 7, unit: "Unit 3: Geometry")
#   maths_igcse.topics.create!(name: "Topic 3.8: Congruency and Similar Shapes", time: 6, unit: "Unit 3: Geometry")
#   maths_igcse.topics.create!(name: "Topic 3.9: Perimeter Area Mensuration", time: 7, unit: "Unit 3: Geometry")
#   maths_igcse.topics.create!(name: "Topic 3.10: Transformational Geometry", time: 5, unit: "Unit 3: Geometry")
#   maths_igcse.topics.create!(name: "Topic 3.11: Vectors", time: 6, unit: "Unit 3: Geometry")
#   maths_igcse.topics.create!(name: "Topic 3.12: Further Trigonometry", time: 8, unit: "Unit 3: Geometry")
#   maths_igcse.topics.create!(name: "Cross-Topic (Unit 3 Geometry)", time: 14, unit: "Unit 3: Geometry")
#   maths_igcse.topics.create!(name: "Master Assessments", time: 3, unit: "Unit 3: Geometry", milestone: true, has_grade: true)
#   maths_igcse.topics.create!(name: "Unit 4: Statistics and Probability", time: 20, unit: "Unit 4: Statistics and Probability")
    # Topic.create!(name: "Topic 4.1: Presenting Data Cumulative Frequency", time: 5, unit: "Unit 4: Statistics and Probability", subject_id: 91)
    # Topic.create!(name: "Topic 4.2: Statistical Measure", time: 6, unit: "Unit 4: Statistics and Probability", subject_id: 91)
    # Topic.create!(name: "Topic 4.3: Probability", time: 7, unit: "Unit 4: Statistics and Probability", subject_id: 91)
    # Topic.create!(name: "Cross-Topic", time: 14, unit: "Unit 4: Statistics and Probability", subject_id: 91)
    # Topic.create!(name: "Master Assessments", time: 3, unit: "Unit 4: Statistics and Probability", milestone: true, has_grade: true, subject_id: 91)
    # Topic.create!(name: "Past Years Question Papers", time: 20, unit: "Unit 4: Statistics and Probability", subject_id: 91)
#
#   Topic.create!(name: "Topic 4.1: Presenting Data Cumulative Frequency", time: 5, unit: "Unit 4: Statistics and Probability", subject_id: 91)
#   Topic.create!(name: "Topic 4.2: Statistical Measure", time: 6, unit: "Unit 4: Statistics and Probability", subject_id: 91)
#   Topic.create!(name: "Topic 4.3: Probability", time: 7, unit: "Unit 4: Statistics and Probability", subject_id: 91)
#   Topic.create!(name: "Cross-Topic", time: 14, unit: "Unit 4: Statistics and Probability", subject_id: 91)
#   Topic.create!(name: "Master Assessments", time: 3, unit: "Unit 4: Statistics and Probability", milestone: true, has_grade: true, subject_id: 91)
#   Topic.create!(name: "Past Years Question Papers", time: 20, unit: "Unit 4: Statistics and Probability", subject_id: 91)
#   maths_igcse.topics.create!(name: "Mock 100%", time: 2, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

#   chemistry_igcse = Subject.create!(
#     name: "Chemistry IGCSE",
#     category: :igcse,
#     )

# chemistry_igcse.topics.create!(name: "Unit 0: Lab", time: 1, unit: "Unit 0: Lab")
# chemistry_igcse.topics.create!(name: "Unit 0: Data Analysis", time: 1, unit: "Unit 0: Data Analysis")
# chemistry_igcse.topics.create!(name: "1.1 States of Matter", time: 4, unit: "Unit 1: Principles of Chemistry")
# chemistry_igcse.topics.create!(name: "1.2 Elements, Compounds and Mixtures", time: 4, unit: "Unit 1: Principles of Chemistry")
# chemistry_igcse.topics.create!(name: "1.3 Atoms and Elements", time: 4, unit: "Unit 1: Principles of Chemistry")
# chemistry_igcse.topics.create!(name: "1.4 Bonding", time: 10, unit: "Unit 1: Principles of Chemistry")
# chemistry_igcse.topics.create!(name: "1.5 Chemical formulae, equations and calculations", time: 6, unit: "Unit 1: Principles of Chemistry")
# chemistry_igcse.topics.create!(name: "1.6 Moles", time: 7, unit: "Unit 1: Principles of Chemistry")
# chemistry_igcse.topics.create!(name: "Warm-Up Mock, Unit 1", time: 5, unit: "Unit 1: Principles of Chemistry", milestone: true, has_grade: true)
# chemistry_igcse.topics.create!(name: "2.1 Group Chemistry", time: 5, unit: "Unit 2: Inorganic Chemistry")
# chemistry_igcse.topics.create!(name: "2.2 Gases in the Atmosphere", time: 5, unit: "Unit 2: Inorganic Chemistry")
# chemistry_igcse.topics.create!(name: "2.3 Reactivity Series", time: 9, unit: "Unit 2: Inorganic Chemistry")
# chemistry_igcse.topics.create!(name: "2.4 Electrolysis", time: 6, unit: "Unit 2: Inorganic Chemistry")
# chemistry_igcse.topics.create!(name: "2.5: Extraction and Uses of Metal", time: 4, unit: "Unit 2: Inorganic Chemistry")
# chemistry_igcse.topics.create!(name: "2.6 Acids and Bases", time: 12, unit: "Unit 2: Inorganic Chemistry")
# chemistry_igcse.topics.create!(name: "2.7 Chemical Tests", time: 13, unit: "Unit 2: Inorganic Chemistry")
# chemistry_igcse.topics.create!(name: "Warm-Up Mock, Unit 2", time: 5, unit: "Unit 2: Inorganic Chemistry", milestone: true, has_grade: true)
# chemistry_igcse.topics.create!(name: "50% Mock Exam", time: 2, unit: "50% Mock Exam", milestone: true, has_grade: true, Mock50: true)
# chemistry_igcse.topics.create!(name: "3.1: Energetics", time: 6, unit: "Unit 3: Physical Chemistry")
# chemistry_igcse.topics.create!(name: "3.2 Rates of Reaction", time: 8, unit: "Unit 3: Physical Chemistry")
# chemistry_igcse.topics.create!(name: "3.3: Reversible Reactions and Equilibria", time: 8, unit: "Unit 3: Physical Chemistry")
# chemistry_igcse.topics.create!(name: "Warm-Up Mock, Unit 3", time: 5, unit: "Unit 3: Physical Chemistry", milestone: true, has_grade: true)
# chemistry_igcse.topics.create!(name: "4.1 Introduction", time: 4, unit: "Unit 4: Organic Chemistry")
# chemistry_igcse.topics.create!(name: "4.2 Alkanes", time: 2, unit: "Unit 4: Organic Chemistry")
# chemistry_igcse.topics.create!(name: "4.3: Alkenes", time: 2, unit: "Unit 4: Organic Chemistry")
# chemistry_igcse.topics.create!(name: "4.4 Crude Oil", time: 6, unit: "Unit 4: Organic Chemistry")
# chemistry_igcse.topics.create!(name: "4.5 Alcohols", time: 3, unit: "Unit 4: Organic Chemistry")
# chemistry_igcse.topics.create!(name: "4.6 Carboxylic Acids", time: 2, unit: "Unit 4: Organic Chemistry")
# chemistry_igcse.topics.create!(name: "4.7 Synthetic Polymers", time: 3, unit: "Unit 4: Organic Chemistry")
# chemistry_igcse.topics.create!(name: "Warm-Up Mock, Unit 4", time: 2, unit: "Unit 4: Organic Chemistry", milestone: true, has_grade: true)
# chemistry_igcse.topics.create!(name: "Exam Preparation", time: 19, unit: "Exam Preparation")
# chemistry_igcse.topics.create!(name: "100% Mock Exam", time: 2, unit: "100% Mock", milestone: true, has_grade: true, Mock100: true)

#   physics_igcse = Subject.create!(
#     name: "Physics IGCSE",
#     category: :igcse,
#     )

#     physics_igcse.topics.create!(name: "Topic 1.1 - Movement, Position & Velocity", time: 6, unit: "Unit 1 - Movement and Forces")
#     physics_igcse.topics.create!(name: "Topic 1.2 - Forces", time: 6, unit: "Unit 1 - Movement and Forces")
#     physics_igcse.topics.create!(name: "Topic 1.3 - Forces of Stopping Distances of Vehicles", time: 3, unit: "Unit 1 - Movement and Forces")
#     physics_igcse.topics.create!(name: "Topic 1.4 - Falling Objects", time: 3, unit: "Unit 1 - Movement and Forces")
#     physics_igcse.topics.create!(name: "Topic 1.5 - Extension and Hooke’s Law", time: 6, unit: "Unit 1 - Movement and Forces")
#     physics_igcse.topics.create!(name: "Topic 1.6 - Momentum", time: 7, unit: "Unit 1 - Movement and Forces")
#     physics_igcse.topics.create!(name: "Topic 1.7 - Moments", time: 7, unit: "Unit 1 - Movement and Forces")
#     physics_igcse.topics.create!(name: "Topic 2.1 - Properties of Waves", time: 5, unit: "Unit 2 - Waves")
#     physics_igcse.topics.create!(name: "Topic 2.2 - The Electromagnetic Spectrum", time: 5, unit: "Unit 2 - Waves")
#     physics_igcse.topics.create!(name: "Topic 2.3 - Light", time: 8, unit: "Unit 2 - Waves")
#     physics_igcse.topics.create!(name: "Topic 2.4 - Sound", time: 7, unit: "Unit 2 - Waves")
#     physics_igcse.topics.create!(name: "Topic 3.1 - Density and Pressure", time: 5, unit: "Unit 3 - Solids, Liquids, and Gases")
#     physics_igcse.topics.create!(name: "Topic 3.2 - Change of State", time: 5, unit: "Unit 3 - Solids, Liquids, and Gases")
#     physics_igcse.topics.create!(name: "Topic 3.3 - Ideal Gases", time: 8, unit: "Unit 3 - Solids, Liquids, and Gases")
#     physics_igcse.topics.create!(name: "Topic 4.1 - Energy Transfers and Stores", time: 4, unit: "Unit 4 - Energy Resources and Energy Transfers")
#     physics_igcse.topics.create!(name: "Topic 4.2 - Energy Transfers - Heat", time: 5, unit: "Unit 4 - Energy Resources and Energy Transfers")
#     physics_igcse.topics.create!(name: "Topic 4.3 - Work and Power", time: 5, unit: "Unit 4 - Energy Resources and Energy Transfers")
#     physics_igcse.topics.create!(name: "Topic 4.4 - Energy Resources and Electricity Generation", time: 9, unit: "Unit 4 - Energy Resources and Energy Transfers")
#     physics_igcse.topics.create!(name: "Mock 50%", time: 2, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
#     physics_igcse.topics.create!(name: "Topic 5.1 - Electrical Current, Potential Difference and Resistance", time: 4, unit: "Unit 5 - Electricity")
#     physics_igcse.topics.create!(name: "Topic 5.2 - Circuit Components - Series and Parallel Circuits", time: 7, unit: "Unit 5 - Electricity")
#     physics_igcse.topics.create!(name: "Topic 5.3 - Mains Electricity and Electrical Power", time: 4, unit: "Unit 5 - Electricity")
#     physics_igcse.topics.create!(name: "Topic 5.4 - Static Electricity", time: 7, unit: "Unit 5 - Electricity")
#     physics_igcse.topics.create!(name: "Topic 6.1 - Magnetism", time: 5, unit: "Unit 6 - Magnetism and Electromagnetism")
#     physics_igcse.topics.create!(name: "Topic 6.2 - Electromagnetism", time: 5, unit: "Unit 6 - Magnetism and Electromagnetism")
#     physics_igcse.topics.create!(name: "Topic 6.3 - Electromagnetic Induction", time: 9, unit: "Unit 6 - Magnetism and Electromagnetism")
#     physics_igcse.topics.create!(name: "Topic 7.1 - Atomic Model", time: 4, unit: "Unit 7 - Radioactivity and Particles")
#     physics_igcse.topics.create!(name: "Topic 7.2 - Radioactivity", time: 6, unit: "Unit 7 - Radioactivity and Particles")
#     physics_igcse.topics.create!(name: "Topic 7.3 Fission and Fusion", time: 7, unit: "Unit 7 - Radioactivity and Particles")
#     physics_igcse.topics.create!(name: "Topic 8.1 - Motion in the Universe", time: 5, unit: "Unit 8 - Astrophysics")
#     physics_igcse.topics.create!(name: "Topic 8.2 - Stellar Evolution", time: 5, unit: "Unit 8 - Astrophysics")
#     physics_igcse.topics.create!(name: "Topic 8.3 - Cosmology", time: 7, unit: "Unit 8 - Astrophysics")
#     physics_igcse.topics.create!(name: "Getting Ready for Mock Stage 2", time: 2, unit: "Unit 8 - Astrophysics")
#     physics_igcse.topics.create!(name: "Mock 100%", time: 2, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

#   biology_igcse = Subject.create!(
#     name: "Biology IGCSE",
#     category: :igcse,
#     )

#     biology_igcse.topics.create!(name: "Topic 1.1 Nature and Variety of Living Organisms", time: 4, unit: "Unit 1: Characteristics and Classification of Living Organisms")
#     biology_igcse.topics.create!(name: "Topic 1.2 Classification of Organisms", time: 4, unit: "Unit 1: Characteristics and Classification of Living Organisms")
#     biology_igcse.topics.create!(name: "Topic 2.1 Levels of Organisation", time: 4, unit: "Unit 2: Organisation of the Organism")
#     biology_igcse.topics.create!(name: "Topic 2.2 Cells, Cell Structures, Cell Differentiation and Stem Cells", time: 4, unit: "Unit 2: Organisation of the Organism")
#     biology_igcse.topics.create!(name: "Topic 3.1 Biological Molecules", time: 4, unit: "Unit 3: Biological Molecules")
#     biology_igcse.topics.create!(name: "Topic 4.1 Enzymes", time: 4, unit: "Unit 4: Enzymes")
#     biology_igcse.topics.create!(name: "Topic 5.1 Movement of Substances In and Out of Cells", time: 4, unit: "Unit 5: Movement of Substances")
#     biology_igcse.topics.create!(name: "Topic 6.1 Photosynthesis and Leaf Structure", time: 4, unit: "Unit 6: Plant Nutrition")
#     biology_igcse.topics.create!(name: "Topic 7.1 Human Nutrition and the Digestive System", time: 4, unit: "Unit 7: Human Nutrition and the Digestive System")
#     biology_igcse.topics.create!(name: "Topic 8.1 General Transport Introduction", time: 4, unit: "Unit 8: Transport in Plants")
#     biology_igcse.topics.create!(name: "Topic 8.2 Transport in Plants", time: 4, unit: "Unit 8: Transport in Plants")
#     biology_igcse.topics.create!(name: "Topic 9.1 Transport in Humans", time: 4, unit: "Unit 9: Transport in Humans")
#     biology_igcse.topics.create!(name: "Topic 10.1 Diseases", time: 4, unit: "Unit 10: Diseases and Immunity")
#     biology_igcse.topics.create!(name: "Topic 10.2 Immunity", time: 4, unit: "Unit 10: Diseases and Immunity")
#     biology_igcse.topics.create!(name: "Topic 11.1 Gas Exchange in Humans", time: 4, unit: "Unit 11: Gas Exchange")
#     biology_igcse.topics.create!(name: "Topic 11.2 Gas Exchange in Plants", time: 4, unit: "Unit 11: Gas Exchange")
#     biology_igcse.topics.create!(name: "Topic 12.1 Aerobic and Anaerobic Respiration", time: 4, unit: "Unit 12: Respiration")
#     biology_igcse.topics.create!(name: "Topic 13.1 Excretion", time: 4, unit: "Unit 13: Excretion")
#     biology_igcse.topics.create!(name: "Topic 14.1 Homeostasis", time: 4, unit: "Unit 14: Coordination and Response")
#     biology_igcse.topics.create!(name: "Topic 14.2 The Nervous System", time: 4, unit: "Unit 14: Coordination and Response")
#     biology_igcse.topics.create!(name: "Topic 14.3 Sense Organs", time: 4, unit: "Unit 14: Coordination and Response")
#     biology_igcse.topics.create!(name: "Topic 14.4 The Endocrine System", time: 4, unit: "Unit 14: Coordination and Response")
#     biology_igcse.topics.create!(name: "Topic 14.5 Tropic Responses in Plants", time: 4, unit: "Unit 14: Coordination and Response")
#     biology_igcse.topics.create!(name: "Topic 15.1 Drugs", time: 4, unit: "Unit 15: Drugs")
#     biology_igcse.topics.create!(name: "Mock 50%", time: 2, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
#     biology_igcse.topics.create!(name: "Topic 16.1 Sexual vs Asexual Reproduction", time: 4, unit: "Unit 16: Reproduction")
#     biology_igcse.topics.create!(name: "Topic 16.2 Reproduction in Plants", time: 4, unit: "Unit 16: Reproduction")
#     biology_igcse.topics.create!(name: "Topic 16.3 Reproduction in Humans", time: 4, unit: "Unit 16: Reproduction")
#     biology_igcse.topics.create!(name: "Topic 17.1 Chromosomes, Genes and Protein Synthesis", time: 4, unit: "Unit 17: Inheritance")
#     biology_igcse.topics.create!(name: "Topic 17.2 Mitosis and Meiosis", time: 4, unit: "Unit 17: Inheritance")
#     biology_igcse.topics.create!(name: "Topic 17.3 Monohybrid Inheritance", time: 4, unit: "Unit 17: Inheritance")
#     biology_igcse.topics.create!(name: "Topic 18.1 Variation and Adaptation", time: 4, unit: "Unit 18: Variation and Selection")
#     biology_igcse.topics.create!(name: "Topic 18.2 Natural and Artificial Selection", time: 4, unit: "Unit 18: Variation and Selection")
#     biology_igcse.topics.create!(name: "Topic 19.1 Energy Flow and Food Chains", time: 4, unit: "Unit 19: Organisms and Their Environment")
#     biology_igcse.topics.create!(name: "Topic 19.2 Ecology and Populations", time: 4, unit: "Unit 19: Organisms and Their Environment")
#     biology_igcse.topics.create!(name: "Topic 19.3 Cycles Within Ecosystems", time: 4, unit: "Unit 19: Organisms and Their Environment")
#     biology_igcse.topics.create!(name: "Topic 20.1 Food Supply and Production", time: 4, unit: "Unit 20: Human Influences on the Environment")
#     biology_igcse.topics.create!(name: "Topic 20.2 Habitat Destruction and Pollution", time: 4, unit: "Unit 20: Human Influences on the Environment")
#     biology_igcse.topics.create!(name: "Topic 20.3 Conservation", time: 4, unit: "Unit 20: Human Influences on the Environment")
#     biology_igcse.topics.create!(name: "Topic 21.1 Biotechnology", time: 4, unit: "Unit 21: Biotechnology and Genetic Modification")
#     biology_igcse.topics.create!(name: "Topic 21.2 Genetic Modification", time: 4, unit: "Unit 21: Biotechnology and Genetic Modification")
#     biology_igcse.topics.create!(name: "Topic 21.3 Cloning", time: 4, unit: "Unit 21: Biotechnology and Genetic Modification")
#     biology_igcse.topics.create!(name: "Topic 22.1 Revision Quizzes", time: 4, unit: "Unit 22: Revision")
#     biology_igcse.topics.create!(name: "Mock 100%", time: 2, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

# business_igcse = Subject.create!(
#   name: "Business IGCSE",
#   category: :igcse,
#   )

#   business_igcse.topics.create!(name: "Business Objectives", time: 5, unit: "Unit 1: Business Activity and Influences on Business")
#   business_igcse.topics.create!(name: "Types of Organisation", time: 5, unit: "Unit 1: Business Activity and Influences on Business")
#   business_igcse.topics.create!(name: "Classification of Businesses", time: 6, unit: "Unit 1: Business Activity and Influences on Business")
#   business_igcse.topics.create!(name: "Decisions on Location", time: 5, unit: "Unit 1: Business Activity and Influences on Business")
#   business_igcse.topics.create!(name: "Business and the International Community", time: 4, unit: "Unit 1: Business Activity and Influences on Business")
#   business_igcse.topics.create!(name: "Government Objectives and Policies", time: 5, unit: "Unit 1: Business Activity and Influences on Business")
#   business_igcse.topics.create!(name: "External Factors", time: 6, unit: "Unit 1: Business Activity and Influences on Business")
#   business_igcse.topics.create!(name: "What Makes a Business Successful?", time: 7, unit: "Unit 1: Business Activity and Influences on Business")
#   business_igcse.topics.create!(name: "Unit 1 Assessment", time: 4, unit: "Unit 1: Business Activity and Influences on Business", milestone: true, has_grade: true)
#   business_igcse.topics.create!(name: "Internal and External Communication", time: 5, unit: "Unit 2 People in Business")
#   business_igcse.topics.create!(name: "Recruitment and Selection Process", time: 6, unit: "Unit 2 People in Business")
#   business_igcse.topics.create!(name: "Training", time: 5, unit: "Unit 2 People in Business")
#   business_igcse.topics.create!(name: "Motivation and Rewards", time: 6, unit: "Unit 2 People in Business")
#   business_igcse.topics.create!(name: "Organisation Structure and Employees", time: 7, unit: "Unit 2 People in Business")
#   business_igcse.topics.create!(name: "Unit 2 Assessment", time: 2, unit: "Unit 2 People in Business", milestone: true, has_grade: true)
#   business_igcse.topics.create!(name: "Assessment Preparation and Support Materials
#   ", time: 4, unit: "Assessment Preparation and Support Materials")
#   business_igcse.topics.create!(name: "Mock 50%", time: 2, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
#   business_igcse.topics.create!(name: "Business Finance Sources", time: 5, unit: "Unit 3 Business Finance")
#   business_igcse.topics.create!(name: "Cash Flow Forecasting", time: 5, unit: "Unit 3 Business Finance")
#   business_igcse.topics.create!(name: "Cost and Break-even Analysis", time: 6, unit: "Unit 3 Business Finance")
#   business_igcse.topics.create!(name: "Financial Documents", time: 5, unit: "Unit 3 Business Finance")
#   business_igcse.topics.create!(name: "Accounts Analysis", time: 5, unit: "Unit 3 Business Finance")
#   business_igcse.topics.create!(name: "Unit 3 Assessment", time: 2, unit: "Unit 3 Business Finance", milestone: true, has_grade: true)
#   business_igcse.topics.create!(name: "Market Research", time: 5, unit: "Unit 4 Marketing")
#   business_igcse.topics.create!(name: "The Market", time: 6, unit: "Unit 4 Marketing")
#   business_igcse.topics.create!(name: "The Marketing Mix", time: 5, unit: "Unit 4 Marketing")
#   business_igcse.topics.create!(name: "Unit 4 Assessment", time: 2, unit: "Unit 4 Marketing", milestone: true, has_grade: true)
#   business_igcse.topics.create!(name: "Economies and Diseconomies of Scale", time: 5, unit: "Unit 5 Business Operations")
#   business_igcse.topics.create!(name: "Production", time: 6, unit: "Unit 5 Business Operations")
#   business_igcse.topics.create!(name: "Factors of Production", time: 5, unit: "Unit 5 Business Operations")
#   business_igcse.topics.create!(name: "Quality", time: 5, unit: "Unit 5 Business Operations")
#   business_igcse.topics.create!(name: "Unit 5 Assessment", time: 2, unit: "Unit 5 Business Operations", milestone: true, has_grade: true)
#   business_igcse.topics.create!(name: "Assessment Preparation and Support Materials
#   ", time: 4, unit: "Assessment Preparation and Support Materials")
#   business_igcse.topics.create!(name: "Mock 100%", time: 2, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

#   portuguese_igcse = Subject.create!(
#     name: "Portuguese IGCSE",
#     category: :igcse,
#     )

#   portuguese_igcse.topics.create!(name: "Sugestões para te tornares um escritor conhecido+ um devorador de livros", time: 5, unit: "Unidade 0")
#   portuguese_igcse.topics.create!(name: "Tópico 1.1: Conseguir-se-á definir VIAGEM? 🤔", time: 5, unit: "Unidade 1: A viagem")
#   portuguese_igcse.topics.create!(name: "Tópico 1.2: Blogue de Viagem", time: 5, unit: "Unidade 1: A viagem")
#   portuguese_igcse.topics.create!(name: "Tópico 1.3: O Vídeo e a Viagem", time: 9, unit: "Unidade 1: A viagem")
#   portuguese_igcse.topics.create!(name: "Tópico 1.4: Relato de Viagem", time: 9, unit: "Unidade 1: A viagem")
#   portuguese_igcse.topics.create!(name: "Tópico 1.5: Texto Informativo", time: 14, unit: "Unidade 1: A viagem")
#   portuguese_igcse.topics.create!(name: "Tópico 1.6: A viagem na literatura", time: 12, unit: "Unidade 1: A viagem")
#   portuguese_igcse.topics.create!(name: "Tópico 2.1: Elementos", time: 33, unit: "Unidade 2: A Presença da Natureza")
#   portuguese_igcse.topics.create!(name: "Tópico 2.2: Catástrofes Naturais", time: 13, unit: "Unidade 2: A Presença da Natureza")
#   portuguese_igcse.topics.create!(name: "Tópico 2.3: A Natureza no Nosso Cotidiano / Quotidiano", time: 11, unit: "Unidade 2: A Presença da Natureza")
#   portuguese_igcse.topics.create!(name: "Tópico 3.1: Fixar normas da língua? Para quê?", time: 12, unit: "Unidade 3: Pontos de vista- A língua portuguesa")
#   portuguese_igcse.topics.create!(name: "Tópico 3.2: O poder das palavras", time: 8, unit: "Unidade 3: Pontos de vista- A língua portuguesa")
#   portuguese_igcse.topics.create!(name: "Tópico 4.1: Comunicação e solidão", time: 19, unit: "Unidade 4: Estamos todos num palco")
#   portuguese_igcse.topics.create!(name: "Mock 50%", time: 2, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
#   portuguese_igcse.topics.create!(name: "Tópico 5.1 - Eu e os Outros", time: 10, unit: "Unidade 5: Eu. Perdido entre a família e os amigos?")
#   portuguese_igcse.topics.create!(name: "Tópico 5.2 - Eu", time: 11, unit: "Unidade 5: Eu. Perdido entre a família e os amigos?")
#   portuguese_igcse.topics.create!(name: "Tópico 6.1 Fugas ao Mundo Material", time: 22, unit: "Unidade 6: Um mundo material")
#   portuguese_igcse.topics.create!(name: "Tópico 6.2 - Presos num mundo material", time: 11, unit: "Unidade 6: Um mundo material")
#   portuguese_igcse.topics.create!(name: "Tópico 7.1 Storytelling", time: 3, unit: "Unidade 7: Acredita ou não. Qual é a verdade?")
#   portuguese_igcse.topics.create!(name: "Tópico 7.2 - Fakenews", time: 10, unit: "Unidade 7: Acredita ou não. Qual é a verdade?")
#   portuguese_igcse.topics.create!(name: "Topico 8.1 - Famosos. Para quem?", time: 10, unit: "Unidade 8: Famosos. Para quem?")
#   portuguese_igcse.topics.create!(name: "Tópico 9.1 -  O fim. Será?", time: 12, unit: "Unidade 9: O fim. Será?")
#   portuguese_igcse.topics.create!(name: "Mock 100%", time: 2, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

# spanish_igcse = Subject.create!(
#   name: "Spanish IGCSE",
#   category: :igcse,
#   )

#   spanish_igcse.topics.create!(name: "¿Quiénes somos?", time: 0, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Tomar conciencia de la identidad personal y cultural", time: 1.5, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Captar la idea general de un texto", time: 1, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Entender el vocabulario específico en un texto largo", time: 2, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Corregir la ortografía, la acentuación y la gramática de un texto", time: 1, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Escribir un texto con correcta ortografía, acentuación y gramática", time: 2, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Taller de escritura", time: 1, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Mundos de ficción", time: 0, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Predecir el contenido de un texto", time: 1.5, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Entender y utilizar connotaciones", time: 1, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Escribir un resumen", time: 2, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Taller de escritura", time: 2, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Mi vida en línea", time: 0, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Encontrar información específica en un texto", time: 1, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Formar una opinión sobre un texto informativo", time: 2, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Formar una opinión sobre un texto de ficción", time: 1, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Escribir mensajes informales", time: 2.5, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Escribir mensajes formales", time: 2, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Taller de escritura", time: 1, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Taller de escritura", time: 1, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "PORTAL de SUPERACIÓN", time: 3, unit: "Fase Uno: Mi entorno")
#   spanish_igcse.topics.create!(name: "Tiempo de ocio", time: 0, unit: "Fase Dos: El tiempo libre")
#   spanish_igcse.topics.create!(name: "Identificar causas y consecuencias", time: 1.5, unit: "Fase Dos: El tiempo libre")
#   spanish_igcse.topics.create!(name: "Identificar una secuencia de eventos", time: 2, unit: "Fase Dos: El tiempo libre")
#   spanish_igcse.topics.create!(name: "Escribir un artículo de opinión", time: 2, unit: "Fase Dos: El tiempo libre")
#   spanish_igcse.topics.create!(name: "Taller de escritura", time: 1, unit: "Fase Dos: El tiempo libre")
#   spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Dos: El tiempo libre")
#   spanish_igcse.topics.create!(name: "Disfraces y máscaras", time: 0, unit: "Fase Dos: El tiempo libre")
#   spanish_igcse.topics.create!(name: "Profundizar en las capacidades de paráfrasis y síntesis", time: 3.5, unit: "Fase Dos: El tiempo libre")
#   spanish_igcse.topics.create!(name: "Taller de escritura", time: 3, unit: "Fase Dos: El tiempo libre")
#   spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Dos: El tiempo libre")
#   spanish_igcse.topics.create!(name: "De viaje por América", time: 0, unit: "Fase Dos: El tiempo libre")
#   spanish_igcse.topics.create!(name: "Identificar los sentimientos del narrador protagonista y otros personajes", time: 1.5, unit: "Fase Dos: El tiempo libre")
#   spanish_igcse.topics.create!(name: "Escribir un texto descriptivo", time: 1, unit: "Fase Dos: El tiempo libre")
#   spanish_igcse.topics.create!(name: "Taller de escritura", time: 3, unit: "Fase Dos: El tiempo libre")
#   spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Dos: El tiempo libre")
#   spanish_igcse.topics.create!(name: "PORTAL de SUPERACIÓN", time: 3, unit: "Fase Dos: El tiempo libre")
#   spanish_igcse.topics.create!(name: "Mock 50%", time: 2, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
#   spanish_igcse.topics.create!(name: "El mundo que habitamos", time: 7.5, unit: "Fase Tres: El medio ambiente")
#   spanish_igcse.topics.create!(name: "Taller de escritura", time: 1, unit: "Fase Tres: El medio ambiente")
#   spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Tres: El medio ambiente")
#   spanish_igcse.topics.create!(name: "Una vida sana", time: 4.5, unit: "Fase Tres: El medio ambiente")
#   spanish_igcse.topics.create!(name: "Taller de escritura", time: 2, unit: "Fase Tres: El medio ambiente")
#   spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Tres: El medio ambiente")
#   spanish_igcse.topics.create!(name: "Usar y tirar", time: 8.5, unit: "Fase Tres: El medio ambiente")
#   spanish_igcse.topics.create!(name: "Taller de escritura", time: 1, unit: "Fase Tres: El medio ambiente")
#   spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Tres: El medio ambiente")
#   spanish_igcse.topics.create!(name: "PORTAL de SUPERACIÓN", time: 3, unit: "Fase Tres: El medio ambiente")
#   spanish_igcse.topics.create!(name: "FASE CUATRO: La sociedad", time: 0, unit: "Fase Cuatro: La sociedad")
#   spanish_igcse.topics.create!(name: "El mundo laboral", time: 5.5, unit: "Fase Cuatro: La sociedad")
#   spanish_igcse.topics.create!(name: "Taller de escritura", time: 1, unit: "Fase Cuatro: La sociedad")
#   spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Cuatro: La sociedad")
#   spanish_igcse.topics.create!(name: "En busca de una vida mejor", time: 3.5, unit: "Fase Cuatro: La sociedad")
#   spanish_igcse.topics.create!(name: "Taller de escritura", time: 3, unit: "Fase Cuatro: La sociedad")
#   spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Cuatro: La sociedad")
#   spanish_igcse.topics.create!(name: "Planes de futuro", time: 2.5, unit: "Fase Cuatro: La sociedad")
#   spanish_igcse.topics.create!(name: "Punto de verificación", time: 3, unit: "Fase Cuatro: La sociedad")
#   spanish_igcse.topics.create!(name: "Taller de escritura", time: 2, unit: "Fase Cuatro: La sociedad")
#   spanish_igcse.topics.create!(name: "PORTAL de SUPERACIÓN", time: 3, unit: "Fase Cuatro: La sociedad")
#   spanish_igcse.topics.create!(name: "Mock 100%", time: 2, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

# sociology_igcse = Subject.create!(
#   name: "Sociology IGCSE",
#   category: :igcse,
#   )

#   sociology_igcse.topics.create!(name: "Topic 1.1 What is Sociology?", time: 6, unit: "Unit 1 Theory and Methods")
#   sociology_igcse.topics.create!(name: "Topic 1.2 How do sociologists study society?", time: 6, unit: "Unit 1 Theory and Methods")
#   sociology_igcse.topics.create!(name: "Topic 1.3 Sampling and sampling methods", time: 6, unit: "Unit 1 Theory and Methods")
#   sociology_igcse.topics.create!(name: "Topic 1.4 Information and data", time: 6, unit: "Unit 1 Theory and Methods")
#   sociology_igcse.topics.create!(name: "Topic 1.5 Evaluating Sociological Research", time: 10.5, unit: "Unit 1 Theory and Methods")
#   sociology_igcse.topics.create!(name: "Topic 2.1 Individuals and Society", time: 5, unit: "Unit 2 Culture, identity and socialisation")
#   sociology_igcse.topics.create!(name: "Topic 2.2 How do we learn to be human?", time: 9.5, unit: "Unit 2 Culture, identity and socialisation")
#   sociology_igcse.topics.create!(name: "Topic 3.1 Wealth & Income and Ethnic Grouping", time: 6, unit: "Unit 3 Social Inequality")
#   sociology_igcse.topics.create!(name: "Topic 3.2 Gender and Social Class", time: 11, unit: "Unit 3 Social Inequality")
#   sociology_igcse.topics.create!(name: "Topic 3.3 What is social stratification?", time: 16.5, unit: "Unit 3 Social Inequality")
#   sociology_igcse.topics.create!(name: "50% Mock Exam Practice", time: 4, unit: "Mock 50%", milestone: true, has_grade: true)
#   sociology_igcse.topics.create!(name: "Mock 50%", time: 4, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
#   sociology_igcse.topics.create!(name: "Topic 4.1 Why families?", time: 6, unit: "Unit 4 Families")
#   sociology_igcse.topics.create!(name: "Topic 4.2 The functions of the family", time: 4, unit: "Unit 4 Families")
#   sociology_igcse.topics.create!(name: "Topic 4.3 What are the main roles within the family?", time: 4, unit: "Unit 4 Families")
#   sociology_igcse.topics.create!(name: "Topic 4.4 What changes are affecting the family?", time: 9.5, unit: "Unit 4 Families")
#   sociology_igcse.topics.create!(name: "Topic 5.1 Introduction", time: 6, unit: "Unit 5 Education")
#   sociology_igcse.topics.create!(name: "Topic 5.2 What is education?", time: 7, unit: "Unit 5 Education")
#   sociology_igcse.topics.create!(name: "Topic 5.3 Differences in Educational Achievement", time: 9.5, unit: "Unit 5 Education")
#   sociology_igcse.topics.create!(name: "Topic 6.1 Normal Behaviour and Deviance", time: 6, unit: "Unit 6 Crime, Deviance and Social Control")
#   sociology_igcse.topics.create!(name: "Topic 6.2 Breaking Society’s Rules", time: 8.5, unit: "Unit 6 Crime, Deviance and Social Control")
#   sociology_igcse.topics.create!(name: "Topic 7.1 What are the mass media?", time: 6, unit: "Unit 7 Media")
#   sociology_igcse.topics.create!(name: "Topic 7.2 Media cultures", time: 6, unit: "Unit 7 Media")
#   sociology_igcse.topics.create!(name: "Topic 7.3 Impact and Influence of the mass media", time: 9, unit: "Unit 7 Media")
#   sociology_igcse.topics.create!(name: "Final Assessment", time: 1, unit: "Final Assessment", milestone: true, has_grade: true)
#   sociology_igcse.topics.create!(name: "100% Mock Practice", time: 4, unit: "100% Mock Practice", milestone: true, has_grade: true)
#   sociology_igcse.topics.create!(name: "Mock 100%", time: 4, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

#   history_igcse = Subject.create!(
#     name: "History IGCSE",
#     category: :igcse,
#     )

#     history_igcse.topics.create!(name: "Topic 1: Reasons for the Cold War", time: 7, unit: "Unit 1: A World Divided: Superpower Relations (1943–72)")
#     history_igcse.topics.create!(name: "Topic 2: Early Developments in the Cold War (1945-49)", time: 7, unit: "Unit 1: A World Divided: Superpower Relations (1943–72)")
#     history_igcse.topics.create!(name: "Topic 3: The Cold War in the 1950s", time: 5, unit: "Unit 1: A World Divided: Superpower Relations (1943–72)")
#     history_igcse.topics.create!(name: "Topic 4: Three Crises: Berlin, Cuba, and Czechoslovakia", time: 7, unit: "Unit 1: A World Divided: Superpower Relations (1943–72)")
#     history_igcse.topics.create!(name: "Topic 5: The Thaw and Moves Toward Detente (1963-72)", time: 6.5, unit: "Unit 1: A World Divided: Superpower Relations (1943–72)")
#     history_igcse.topics.create!(name: "Topic 1: The Red Scare and McCarthyism", time: 7, unit: "Unit 2: Depth Study: A Divided Union: Civil Rights in the USA (1945-74)")
#     history_igcse.topics.create!(name: "Topic 2: Civil Rights in the 1950s", time: 7, unit: "Unit 2: Depth Study: A Divided Union: Civil Rights in the USA (1945-74)")
#     history_igcse.topics.create!(name: "Topic 3: The Impact of Civil Rights Protests (1960-74)", time: 5, unit: "Unit 2: Depth Study: A Divided Union: Civil Rights in the USA (1945-74)")
#     history_igcse.topics.create!(name: "Topic 4: Other Protest Movements: Students, Women, and Anti-Vietnam", time: 7, unit: "Unit 2: Depth Study: A Divided Union: Civil Rights in the USA (1945-74)")
#     history_igcse.topics.create!(name: "Topic 5: Nixon and Watergate", time: 6.5, unit: "Unit 2: Depth Study: A Divided Union: Civil Rights in the USA (1945-74)")
#     history_igcse.topics.create!(name: "Mock 50%", time: 1.5, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
#     history_igcse.topics.create!(name: "Topic 1", time: 6, unit: "Unit 3: Historical Investigation: The Origins and Course of the First World War (1905-18)")
#     history_igcse.topics.create!(name: "Topic 2", time: 5.5, unit: "Unit 3: Historical Investigation: The Origins and Course of the First World War (1905-18)")
#     history_igcse.topics.create!(name: "Topic 3", time: 7, unit: "Unit 3: Historical Investigation: The Origins and Course of the First World War (1905-18)")
#     history_igcse.topics.create!(name: "Topic 4", time: 7, unit: "Unit 3: Historical Investigation: The Origins and Course of the First World War (1905-18)")
#     history_igcse.topics.create!(name: "Topic 5", time: 7, unit: "Unit 3: Historical Investigation: The Origins and Course of the First World War (1905-18)")
#     history_igcse.topics.create!(name: "Topic 1 Progress in the Mid-19th Century", time: 5, unit: "Unit 4: Breadth Study in Change: Changes in Medicine (c.1848-1948)")
#     history_igcse.topics.create!(name: "Topic 2", time: 5.5, unit: "Unit 4: Breadth Study in Change: Changes in Medicine (c.1848-1948)")
#     history_igcse.topics.create!(name: "Topic 3 Accelerating Change (1875-1905)", time: 7, unit: "Unit 4: Breadth Study in Change: Changes in Medicine (c.1848-1948)")
#     history_igcse.topics.create!(name: "Topic 4 Government Action and War (1905-20)-left off", time: 7, unit: "Unit 4: Breadth Study in Change: Changes in Medicine (c.1848-1948)")
#     history_igcse.topics.create!(name: "Topic 5 Advances in Medicine, Surgery, and Public Health (1920-48)", time: 7, unit: "Unit 4: Breadth Study in Change: Changes in Medicine (c.1848-1948)")
#     history_igcse.topics.create!(name: "Mock 100%", time: 1.5, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

#     geography_igcse = Subject.create!(
#       name: "Geography IGCSE",
#       category: :igcse,
#       )

# geography_igcse.topics.create!(name: "Topic 1: Water on Earth", time: 2, unit: "Unit 1: River Environments")
# geography_igcse.topics.create!(name: "Topic 2: River Regimes and Hydrographs", time: 2, unit: "Unit 1: River Environments")
# geography_igcse.topics.create!(name: "Topic 3: River Process", time: 2, unit: "Unit 1: River Environments")
# geography_igcse.topics.create!(name: "Topic 4: River Characteristics", time: 2, unit: "Unit 1: River Environments")
# geography_igcse.topics.create!(name: "Topic 5: River Features", time: 2, unit: "Unit 1: River Environments")
# geography_igcse.topics.create!(name: "Topic 6: Water Uses, Supply & Demand", time: 2, unit: "Unit 1: River Environments")
# geography_igcse.topics.create!(name: "Topic 7: Water Quality & Management", time: 2, unit: "Unit 1: River Environments")
# geography_igcse.topics.create!(name: "Topic 8: River Flooding", time: 2, unit: "Unit 1: River Environments")
# geography_igcse.topics.create!(name: "Topic 9: Rivers & Fieldwork", time: 2, unit: "Unit 1: River Environments")
# geography_igcse.topics.create!(name: "Unit 1 Assignments & Assessment", time: 4, unit: "Unit 1: River Environments", milestone: true, has_grade: true)
# geography_igcse.topics.create!(name: "Topic 1: Coastal Processes", time: 2, unit: "Unit 2 Coastal Environments")
# geography_igcse.topics.create!(name: "Topic 2: Factors Affecting Coasts", time: 2, unit: "Unit 2 Coastal Environments")
# geography_igcse.topics.create!(name: "Topic 3: Coastal Landforms", time: 2, unit: "Unit 2 Coastal Environments")
# geography_igcse.topics.create!(name: "Topic 4: Coastal Ecosystems", time: 2, unit: "Unit 2 Coastal Environments")
# geography_igcse.topics.create!(name: "Topic 5: Threats Coastal Ecosystems", time: 2, unit: "Unit 2 Coastal Environments")
# geography_igcse.topics.create!(name: "Topic 6: Coastal Conflicts", time: 2, unit: "Unit 2 Coastal Environments")
# geography_igcse.topics.create!(name: "Topic 7: Coastal Flooding", time: 2, unit: "Unit 2 Coastal Environments")
# geography_igcse.topics.create!(name: "Topic 8: Coastal Management", time: 2, unit: "Unit 2 Coastal Environments")
# geography_igcse.topics.create!(name: "Topic 9: Coastal Fieldwork", time: 2, unit: "Unit 2 Coastal Environments")
# geography_igcse.topics.create!(name: "Unit 2 Assignments & Assessment", time: 4, unit: "Unit 2 Coastal Environments", milestone: true, has_grade: true)
# geography_igcse.topics.create!(name: "Topic 1 - Different Types of Hazard", time: 2, unit: "Unit 3 Hazardous Environments")
# geography_igcse.topics.create!(name: "Topic 2 - Tropical Cyclones", time: 2, unit: "Unit 3 Hazardous Environments")
# geography_igcse.topics.create!(name: "Topic 3 - Volcanic Eruptions and Earthquakes", time: 2, unit: "Unit 3 Hazardous Environments")
# geography_igcse.topics.create!(name: "Topic 4 - The Scale of Tectonic Hazards", time: 2, unit: "Unit 3 Hazardous Environments")
# geography_igcse.topics.create!(name: "Topic 5 - Impacts of Tectonic Hazards", time: 2, unit: "Unit 3 Hazardous Environments")
# geography_igcse.topics.create!(name: "Topic 6 - Reasons for living in high-risk areas", time: 2, unit: "Unit 3 Hazardous Environments")
# geography_igcse.topics.create!(name: "Topic 7 - Tropical cyclones and their impact", time: 2, unit: "Unit 3 Hazardous Environments")
# geography_igcse.topics.create!(name: "Topic 8 - Predicting and preparing for earthquakes", time: 2, unit: "Unit 3 Hazardous Environments")
# geography_igcse.topics.create!(name: "Topic 9 - Responding to hazards", time: 2, unit: "Unit 3 Hazardous Environments")
# geography_igcse.topics.create!(name: "Unit 3 Assignments & Assessment", time: 4, unit: "Unit 3 Hazardous Environments", milestone: true, has_grade: true)
# geography_igcse.topics.create!(name: "Mock 50%", time: 2, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
# geography_igcse.topics.create!(name: "Topic 1: Economic Activity", time: 2, unit: "Unit 4 Economic Activity and Energy")
# geography_igcse.topics.create!(name: "Topic 2: The Location of Industries", time: 2, unit: "Unit 4 Economic Activity and Energy")
# geography_igcse.topics.create!(name: "Topic 3: The Changing Location of Industry", time: 2, unit: "Unit 4 Economic Activity and Energy")
# geography_igcse.topics.create!(name: "Topic 4: Change in Economic Sectors", time: 2, unit: "Unit 4 Economic Activity and Energy")
# geography_igcse.topics.create!(name: "Topic 5: Impact of Sector Shifts", time: 2, unit: "Unit 4 Economic Activity and Energy")
# geography_igcse.topics.create!(name: "Topic 6: Informal Employment", time: 2, unit: "Unit 4 Economic Activity and Energy")
# geography_igcse.topics.create!(name: "Topic 7: Population and Resources", time: 2, unit: "Unit 4 Economic Activity and Energy")
# geography_igcse.topics.create!(name: "Topic 8: The Demand for Energy", time: 2, unit: "Unit 4 Economic Activity and Energy")
# geography_igcse.topics.create!(name: "Topic 9: Energy Case Studies", time: 2, unit: "Unit 4 Economic Activity and Energy")
# geography_igcse.topics.create!(name: "Unit 4 Assignments & Assessment", time: 4, unit: "Unit 4 Economic Activity and Energy", milestone: true, has_grade: true)
# geography_igcse.topics.create!(name: "Topic 1: Biomes", time: 2, unit: "Unit 5 Ecosystems and Rural Environments")
# geography_igcse.topics.create!(name: "Topic 2: People and Ecosystems", time: 2, unit: "Unit 5 Ecosystems and Rural Environments")
# geography_igcse.topics.create!(name: "Topic 3: Rural Environments", time: 2, unit: "Unit 5 Ecosystems and Rural Environments")
# geography_igcse.topics.create!(name: "Topic 4: Rural Change in the UK", time: 2, unit: "Unit 5 Ecosystems and Rural Environments")
# geography_igcse.topics.create!(name: "Topic 5: Changing Rural Environments in India", time: 2, unit: "Unit 5 Ecosystems and Rural Environments")
# geography_igcse.topics.create!(name: "Topic 6: Diversification", time: 2, unit: "Unit 5 Ecosystems and Rural Environments")
# geography_igcse.topics.create!(name: "Topic 7: Rural Management", time: 2, unit: "Unit 5 Ecosystems and Rural Environments")
# geography_igcse.topics.create!(name: "Topic 8: Urban Management", time: 4, unit: "Unit 5 Ecosystems and Rural Environments")
# geography_igcse.topics.create!(name: "Unit 5 Assignments & Assessment", time: 4, unit: "Unit 5 Ecosystems and Rural Environments", milestone: true, has_grade: true)
# geography_igcse.topics.create!(name: "Topic 1: Fragile Environments", time: 2, unit: "Unit 6 Fragile Environments")
# geography_igcse.topics.create!(name: "Topic 2: Desertification", time: 2, unit: "Unit 6 Fragile Environments")
# geography_igcse.topics.create!(name: "Topic 3: Deforestation", time: 2, unit: "Unit 6 Fragile Environments")
# geography_igcse.topics.create!(name: "Topic 4: Global Warming and Climate Change", time: 2, unit: "Unit 6 Fragile Environments")
# geography_igcse.topics.create!(name: "Unit 6 Assignments & Assessment", time: 4, unit: "Unit 6 Fragile Environments", milestone: true, has_grade: true)
# geography_igcse.topics.create!(name: "Topic 1: Geographical Methods and Techniques", time: 2, unit: "Unit 7 Geographical Methods and Techniques")
# geography_igcse.topics.create!(name: "Topic 2: FIELDWORK", time: 20, unit: "Unit 7 Geographical Methods and Techniques")
# geography_igcse.topics.create!(name: "Mock 100%", time: 8, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

# tt_igse = Subject.create!(
#   name: "Travel & Tourism IGCSE",
#   category: :igcse,
#   )

# tt_igse.topics.create!(name: "Unit 0 - Introduction", time: 1, unit: "Introduction")
# tt_igse.topics.create!(name: "Structure of international travel and tourism industry", time: 3, unit: "Unit 1 - The Travel and Tourism Industry")
# tt_igse.topics.create!(name: "The economic, environmental and socio-cultural impact of travel and tourism", time: 5, unit: "Unit 1 - The Travel and Tourism Industry")
# tt_igse.topics.create!(name: "Role of national governments in forming tourism policy and promotion", time: 3, unit: "Unit 1 - The Travel and Tourism Industry")
# tt_igse.topics.create!(name: "The pattern of demand for international travel and tourism", time: 3, unit: "Unit 1 - The Travel and Tourism Industry")
# tt_igse.topics.create!(name: "Final Assessments", time: 4, unit: "Unit 1 - The Travel and Tourism Industry", milestone: true, has_grade: true)
# tt_igse.topics.create!(name: "The main global features", time: 4, unit: "Unit 2 - Features of worldwide destinations")
# tt_igse.topics.create!(name: "Different Time zones and climates", time: 3, unit: "Unit 2 - Features of worldwide destinations")
# tt_igse.topics.create!(name: "Investigate travel and tourism destinations", time: 3, unit: "Unit 2 - Features of worldwide destinations")
# tt_igse.topics.create!(name: "The features which attract tourists to a particular destination", time: 3, unit: "Unit 2 - Features of worldwide destinations")
# tt_igse.topics.create!(name: "Final Assessments", time: 6, unit: "Unit 2 - Features of worldwide destinations", milestone: true, has_grade: true)
# tt_igse.topics.create!(name: "Deal with customers and colleagues", time: 5, unit: "Unit 3 - Customer care and working procedures")
# tt_igse.topics.create!(name: "Identify the essential personal skills required when working in the travel and tourism industry", time: 4, unit: "Unit 3 - Customer care and working procedures")
# tt_igse.topics.create!(name: "Follow basic procedures when handling customer enquiries, reservations and payments", time: 4, unit: "Unit 3 - Customer care and working procedures")
# tt_igse.topics.create!(name: "Use reference sources to obtain information", time: 4, unit: "Unit 3 - Customer care and working procedures")
# tt_igse.topics.create!(name: "Explore the presentation and promotion of tourist facilities", time: 4, unit: "Unit 3 - Customer care and working procedures")
# tt_igse.topics.create!(name: "Final Assessments", time: 6, unit: "Unit 3 - Customer care and working procedures", milestone: true, has_grade: true)
# tt_igse.topics.create!(name: "Mock 50%", time: 4, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
# tt_igse.topics.create!(name: "Introduction", time: 3, unit: "Unit 4 - Travel and tourism products and services")
# tt_igse.topics.create!(name: "Topic 4.1 - Identify and describe tourism products", time: 5, unit: "Unit 4 - Travel and tourism products and services")
# tt_igse.topics.create!(name: "Topic 4.2 - Explore the roles of tour operators and travel agents", time: 5, unit: "Unit 4 - Travel and tourism products and services")
# tt_igse.topics.create!(name: "Topic 4.3 - Describe support facilities for travel and tourism", time: 5, unit: "Unit 4 - Travel and tourism products and services")
# tt_igse.topics.create!(name: "Topic 4.4 - Explore the features of worldwide transport in relation to major international routes", time: 5, unit: "Unit 4 - Travel and tourism products and services")
# tt_igse.topics.create!(name: "Final Assessments", time: 6, unit: "Unit 4 - Travel and tourism products and services", milestone: true, has_grade: true)
# tt_igse.topics.create!(name: "Introduction", time: 3, unit: "Unit 5 - Marketing and promotion")
# tt_igse.topics.create!(name: "Role and function of marketing and promotion", time: 7, unit: "Unit 5 - Marketing and promotion")
# tt_igse.topics.create!(name: "Market segmentation and targeting", time: 7, unit: "Unit 5 - Marketing and promotion")
# tt_igse.topics.create!(name: "Product as part of marketing mix", time: 8, unit: "Unit 5 - Marketing and promotion")
# tt_igse.topics.create!(name: "Price as part of marketing mix", time: 8, unit: "Unit 5 - Marketing and promotion")
# tt_igse.topics.create!(name: "Place as part of the marketing mix", time: 7, unit: "Unit 5 - Marketing and promotion")
# tt_igse.topics.create!(name: "Promotion as part of marketing mix", time: 8, unit: "Unit 5 - Marketing and promotion")
# tt_igse.topics.create!(name: "Final Assessments", time: 6, unit: "Unit 5 - Marketing and promotion", milestone: true, has_grade: true)
# tt_igse.topics.create!(name: "The operation, role, and function of tourist boards and tourist information centres", time: 5, unit: "Unit 6 - The marketing and promotion of visitor services")
# tt_igse.topics.create!(name: "The provision of tourist products and services", time: 5, unit: "Unit 6 - The marketing and promotion of visitor services")
# tt_igse.topics.create!(name: "Basic principles of marketing and promotion", time: 5, unit: "Unit 6 - The marketing and promotion of visitor services")
# tt_igse.topics.create!(name: "The marketing mix", time: 5, unit: "Unit 6 - The marketing and promotion of visitor services")
# tt_igse.topics.create!(name: "Leisure travel services", time: 5, unit: "Unit 6 - The marketing and promotion of visitor services")
# tt_igse.topics.create!(name: "Business travel services", time: 5, unit: "Unit 6 - The marketing and promotion of visitor services")
# tt_igse.topics.create!(name: "Assessments - Coursework", time: 15, unit: "Unit 6 - The marketing and promotion of visitor services", milestone: true, has_grade: true)
# tt_igse.topics.create!(name: "Mock 100%", time: 3, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)


# english_igcse = Subject.create!(
#   name: "English IGCSE",
#   category: :igcse,
#   )

#   english_igcse.topics.create!(name: "Topic 1.1: Note-Taking: Cornell Notes and Annotating", time: 2, unit: "Unit 1: The Foundations")
#   english_igcse.topics.create!(name: "Topic 1.2: Language Matters", time: 9.2, unit: "Unit 1: The Foundations")
#   english_igcse.topics.create!(name: "Topic 1.3: Audience and Purpose", time: 5.6, unit: "Unit 1: The Foundations")
#   english_igcse.topics.create!(name: "Topic 1.4: The Paragraph", time: 5.2, unit: "Unit 1: The Foundations")
#   english_igcse.topics.create!(name: "Topic 1.5: The Essay", time: 2, unit: "Unit 1: The Foundations")
#   english_igcse.topics.create!(name: "Topic 1.6: Creating Meaning", time: 7.8, unit: "Unit 1: The Foundations")
#   english_igcse.topics.create!(name: "Topic 2.1: Letters", time: 2.8, unit: "Unit 2: Language and Thought")
#   english_igcse.topics.create!(name: "Topic 2.2: Autobiography and Biography", time: 1.6, unit: "Unit 2: Language and Thought")
#   english_igcse.topics.create!(name: "Topic 2.3: Articles", time: 2.6, unit: "Unit 2: Language and Thought")
#   english_igcse.topics.create!(name: "Topic 2.4: Reports/Leaflets", time: 1.6, unit: "Unit 2: Language and Thought")
#   english_igcse.topics.create!(name: "Topic 2.5: Speeches", time: 4.6, unit: "Unit 2: Language and Thought")
#   english_igcse.topics.create!(name: "Topic 3.1: Context and Background: Animal Farm", time: 8.7, unit: "Unit 3: Language and Power")
#   english_igcse.topics.create!(name: "Topic 3.2: Chapters 1-3", time: 6.1, unit: "Unit 3: Language and Power")
#   english_igcse.topics.create!(name: "Topic 3.3: Chapters 4-6", time: 6.1, unit: "Unit 3: Language and Power")
#   english_igcse.topics.create!(name: "Topic 3.4: Chapters 7-10", time: 5.1, unit: "Unit 3: Language and Power")
#   english_igcse.topics.create!(name: "Topic 3.5: Argumentative Writing", time: 4.6, unit: "Unit 3: Language and Power")
#   english_igcse.topics.create!(name: "Topic 4.1: The Comparative Essay", time: 2.8, unit: "Unit 4 The Individual and Social Responsibility")
#   english_igcse.topics.create!(name: "Mock 50%", time: 8.7, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
#   english_igcse.topics.create!(name: "Topic 5.1: Inquiry Project", time: 4.2, unit: "Unit 5: The Comparative Essay")
#   english_igcse.topics.create!(name: "Topic 6.1: Introduction to Descriptive Writing. Painting with Words.", time: 3.8, unit: "Unit 6: Descriptive Writing and Fahrenheit 451")
#   english_igcse.topics.create!(name: "Topic 6.2: Introduction to Fahrenheit 451. Context is Everything!", time: 2.6, unit: "Unit 6: Descriptive Writing and Fahrenheit 452")
#   english_igcse.topics.create!(name: "Topic 6.3: Fahrenheit 451: The Hearth and the Salamander", time: 6.1, unit: "Unit 6: Descriptive Writing and Fahrenheit 453")
#   english_igcse.topics.create!(name: "Topic 6.4: Fahrenheit 451: Sieve and Sand", time: 6.1, unit: "Unit 6: Descriptive Writing and Fahrenheit 454")
#   english_igcse.topics.create!(name: "Topic 6.5: Fahrenheit 451: Burning Bright", time: 2.1, unit: "Unit 6: Descriptive Writing and Fahrenheit 455")
#   english_igcse.topics.create!(name: "Topic 7.1: Elements of Story Telling", time: 11.3, unit: "Unit 7: Narrative Writing and Introduction to Of Mice and Men")
#   english_igcse.topics.create!(name: "Topic 7.2: Conflict - Driving a Story", time: 1.6, unit: "Unit 7: Narrative Writing and Introduction to Of Mice and Men")
#   english_igcse.topics.create!(name: "Topic 7.3: The Shape of a Story - Story Stages, Mood and Tension.", time: 4.6, unit: "Unit 7: Narrative Writing and Introduction to Of Mice and Men")
#   english_igcse.topics.create!(name: "Topic 8.1: Section C of Exam", time: 0.5, unit: "Unit 8: Approaching Section C of Exam")
#   english_igcse.topics.create!(name: "Topic 8.1: Titles in the Section C of Exam", time: 1.5, unit: "Unit 8: Approaching Section C of Exam")
#   english_igcse.topics.create!(name: "Topic 9.1: Revision - Study Tips and Past Papers for Practice.", time: 4.6, unit: "Unit 9: Revision - Study Tips and Past Papers for Practice.")
#   english_igcse.topics.create!(name: "Mock 100%", time: 4.2, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)


# afrikaans = Subject.create!(
#   name: "Afrikaans IGCSE",
#   category: :igcse,
#   )

#   afrikaans.topics.create!(name: "Unit 0: Review", time: 10, unit: "Review")
#   afrikaans.topics.create!(name: "Unit 1: Lees en Beantwoord", time: 5, unit: "Lees en Beantwoord")
#   afrikaans.topics.create!(name: "Unit 2: Dra inligting oor op 'n gegewe vorm", time: 5, unit: "Voltooi die vorm")
#   afrikaans.topics.create!(name: "Unit 3: Lees die leestuk en voltooi die aantekeninge wat volg", time: 5, unit: "Maak aanterkoninge")
#   afrikaans.topics.create!(name: "Unit 4: Maak 'n opsomming van die teks", time: 5, unit: "Maak 'n opsomming")
#   afrikaans.topics.create!(name: "Unit 5: Skryf 'n informele brief", time: 5, unit: "Kort skryfwerk")
#   afrikaans.topics.create!(name: "Unit 6: Hoe om 'n begripstoets te beantwoord", time: 7, unit: "Leesoefening")
#   afrikaans.topics.create!(name: "Unit 7: Langer skryf opdrag", time: 8, unit: "Lang skryfoefening")
#   afrikaans.topics.create!(name: "Mock 50%", time: 3, unit: "50% mock exam", milestone: true, has_grade: true, Mock50: true)
#   afrikaans.topics.create!(name: "Unit 8: Luisteroefening 1", time: 5, unit: "Luisteroefening 1")
#   afrikaans.topics.create!(name: "Unit 9: Luisteroefening 2", time: 5, unit: "Luisteroefening 2")
#   afrikaans.topics.create!(name: "Unit 10: Die Skoenmaker se Kitaar", time: 5, unit: "Die Skoenmaker se Kitaar")
#   afrikaans.topics.create!(name: "Unit 11: Die Houtkapper", time: 5, unit: "Die Houtkapper")
#   afrikaans.topics.create!(name: "Unit 12: Ek is jammer", time: 5, unit: "Ek is jammer")
#   afrikaans.topics.create!(name: "Extra Leesoefening", time: 5, unit: "Extra Leesoefening")
#   afrikaans.topics.create!(name: "Exam preparation", time: 5, unit: "Exam preparation")
#   afrikaans.topics.create!(name: "100% Mock exam", time: 3, unit: "100% mock exam", milestone: true, has_grade: true, Mock100: true)

#   portuguesesl = Subject.create!(
#     name: "Portuguese Second Language GCSE",
#     category: :igcse,
#     )

#     portuguesesl.topics.create!(name: "1.1 O Alfabeto (The Alphabet)", time: 2.5, unit: "Unidade 1")
#     portuguesesl.topics.create!(name: "1.2 Saudações Formais e Informais (Formal and Informal greetings)", time: 1.5, unit: "Unidade 1")
#     portuguesesl.topics.create!(name: "1.3 Pronomes (Pronouns)", time: 2.5, unit: "Unidade 1")
#     portuguesesl.topics.create!(name: "1.4 Apresentação Pessoal (Introducing Yourself)", time: 3.5, unit: "Unidade 1")
#     portuguesesl.topics.create!(name: "2.1 O verbo SER", time: 3.5, unit: "Unidade 2")
#     portuguesesl.topics.create!(name: "2.2 Palavras femininas e Masculinas e Profissões", time: 1.5, unit: "Unidade 2")
#     portuguesesl.topics.create!(name: "2.3 Familia, o verbo ter e os possetivos", time: 4.0, unit: "Unidade 2")
#     portuguesesl.topics.create!(name: "2.4 O verbo TER", time: 4.0, unit: "Unidade 2")
#     portuguesesl.topics.create!(name: "3.1 O verbo ESTAR e os sentimentos", time: 3.5, unit: "Unidade 3")
#     portuguesesl.topics.create!(name: "3.2 Verbos regulares no Presente de Indicativo", time: 4.0, unit: "Unidade 3")
#     portuguesesl.topics.create!(name: "3.3 Rotina", time: 4.0, unit: "Unidade 3")
#     portuguesesl.topics.create!(name: "3.4 Dias da semana - Meses do ano", time: 3.0, unit: "Unidade 3")
#     portuguesesl.topics.create!(name: "4.1 A morada e meios de transportes", time: 2.5, unit: "Unidade 4")
#     portuguesesl.topics.create!(name: "4.2 As horas", time: 3.0, unit: "Unidade 4")
#     portuguesesl.topics.create!(name: "4.3 vestuário", time: 3.0, unit: "Unidade 4")
#     portuguesesl.topics.create!(name: "4.4 As cores e a concordância", time: 4.0, unit: "Unidade 4")
#     portuguesesl.topics.create!(name: "5.1 Comidas", time: 3.0, unit: "Unidade 5")
#     portuguesesl.topics.create!(name: "5.2 Fazer um pedido", time: 4.0, unit: "Unidade 5")
#     portuguesesl.topics.create!(name: "5.3 Expressar gosto e preferência", time: 4.0, unit: "Unidade 5")
#     portuguesesl.topics.create!(name: "5.4 Hábitos saudáveis", time: 3.5, unit: "Unidade 5")
#     portuguesesl.topics.create!(name: "5.5  Verbos irregulares no presente", time: 4.0, unit: "Unidade 5")
#     portuguesesl.topics.create!(name: "Mock Exam 50%", time: 3.0, unit: "Mock Exam 50%", milestone: true, has_grade: true, Mock50: true)
#     portuguesesl.topics.create!(name: "6.1 Pronomes interrogativos", time: 4.0, unit: "Unidade 6")
#     portuguesesl.topics.create!(name: "6.2 Imperativo", time: 4.0, unit: "Unidade 6")
#     portuguesesl.topics.create!(name: "6.3 Gerúndio e Particípio", time: 4.0, unit: "Unidade 6")
#     portuguesesl.topics.create!(name: "6.4 Partes do corpo + consulta médica", time: 4.0, unit: "Unidade 6")
#     portuguesesl.topics.create!(name: "6.5 Adjetivos e descrição fisica", time: 3.0, unit: "Unidade 6")
#     portuguesesl.topics.create!(name: "6.6 Futuro na forma de presente", time: 3.5, unit: "Unidade 6")
#     portuguesesl.topics.create!(name: "7.1 A escola", time: 3.0, unit: "Unidade 7")
#     portuguesesl.topics.create!(name: "7.2 Preposições", time: 4.0, unit: "Unidade 7")
#     portuguesesl.topics.create!(name: "7.3 Lugares da cidade + dar indicações", time: 4.0, unit: "Unidade 7")
#     portuguesesl.topics.create!(name: "7.4 Desportos e hábitos saudáveis", time: 4.5, unit: "Unidade 7")
#     portuguesesl.topics.create!(name: "7.5 Partes da Casa", time: 6.5, unit: "Unidade 7")
#     portuguesesl.topics.create!(name: "8.1 Pretérito perfeito", time: 5.0, unit: "Unidade 8")
#     portuguesesl.topics.create!(name: "8.2 Relato de viagem", time: 4.0, unit: "Unidade 8")
#     portuguesesl.topics.create!(name: "8.3 Pretérito Imperfeito", time: 4.0, unit: "Unidade 8")
#     portuguesesl.topics.create!(name: "8.4 A infância", time: 6.0, unit: "Unidade 8")
#     portuguesesl.topics.create!(name: "9.1 Adverbios e conjunções", time: 4.0, unit: "Unidade 9")
#     portuguesesl.topics.create!(name: "9.2 Fazer comparações + diminutivos e aumentativos", time: 4.0, unit: "Unidade 9")
#     portuguesesl.topics.create!(name: "9.3 O futuro", time: 4.0, unit: "Unidade 9")
#     portuguesesl.topics.create!(name: "9.4 Expressões idiomáticas", time: 2.0, unit: "Unidade 9")
#     portuguesesl.topics.create!(name: "9.5 Colocação dos pronomes", time: 4.0, unit: "Unidade 9")
#     portuguesesl.topics.create!(name: "9.6 Conjuntivo", time: 5.0, unit: "Unidade 9")
#     portuguesesl.topics.create!(name: "Mock Exam 100%", time: 1.5, unit: "Mock Exam 100%", milestone: true, has_grade: true, Mock100: true)

#     spanishsl = Subject.create!(
#       name: "Spanish Foreign Language IGCSE",
#       category: :igcse,
#       )

#       spanishsl.topics.create!(name: "0.1. Aprender español", time: 2, unit: "Unidad 1")
#       spanishsl.topics.create!(name: "1.1. Rincón gramatical", time: 1, unit: "Unidad 1")
#       spanishsl.topics.create!(name: "1.1. Yo y mis cosas", time: 3, unit: "Unidad 1")
#       spanishsl.topics.create!(name: "1.1. Punto de verificación", time: 3, unit: "Unidad 1")
#       spanishsl.topics.create!(name: "1.2. Rincón gramatical", time: 1, unit: "Unidad 1")
#       spanishsl.topics.create!(name: "1.2. Mi día a día", time: 3, unit: "Unidad 1")
#       spanishsl.topics.create!(name: "1.2. Punto de verificación", time: 3, unit: "Unidad 1")
#       spanishsl.topics.create!(name: "1.3. Rincón gramatical", time: 1, unit: "Unidad 1")
#       spanishsl.topics.create!(name: "1.3. Mi casa y mi ciudad", time: 3, unit: "Unidad 1")
#       spanishsl.topics.create!(name: "1.3. Punto de verificación", time: 3, unit: "Unidad 1")
#       spanishsl.topics.create!(name: "1.4. Rincón gramatical", time: 1, unit: "Unidad 1")
#       spanishsl.topics.create!(name: "1.4. Mi escuela, mi clase y mis profesores", time: 3, unit: "Unidad 1")
#       spanishsl.topics.create!(name: "1.4. Punto de verificación", time: 3, unit: "Unidad 1")
#       spanishsl.topics.create!(name: "2.1. Rincón gramatical", time: 1, unit: "Unidad 2")
#       spanishsl.topics.create!(name: "2.1. Familia y amigos", time: 3, unit: "Unidad 2")
#       spanishsl.topics.create!(name: "2.1. Punto de verificación", time: 3, unit: "Unidad 2")
#       spanishsl.topics.create!(name: "2.2. Rincón gramatical", time: 1, unit: "Unidad 2")
#       spanishsl.topics.create!(name: "2.2. Mascotas y aficiones", time: 3, unit: "Unidad 2")
#       spanishsl.topics.create!(name: "2.2. Punto de verificación", time: 3, unit: "Unidad 2")
#       spanishsl.topics.create!(name: "2.3. Rincón gramatical", time: 1, unit: "Unidad 2")
#       spanishsl.topics.create!(name: "2.3. Me gusta el deporte", time: 3, unit: "Unidad 2")
#       spanishsl.topics.create!(name: "2.3. Punto de verificación", time: 3, unit: "Unidad 2")
#       spanishsl.topics.create!(name: "2.4. Rincón gramatical", time: 1, unit: "Unidad 2")
#       spanishsl.topics.create!(name: "2.4. Dieta saludable", time: 3, unit: "Unidad 2")
#       spanishsl.topics.create!(name: "2.4. Punto de verificación", time: 3, unit: "Unidad 2")
#       spanishsl.topics.create!(name: "Mock Exam 50%", time: 3, unit: "Mock Exam 50%", milestone: true, has_grade: true, Mock50: true)
#       spanishsl.topics.create!(name: "3.1. Rincón gramatical", time: 1, unit: "Unidad 3")
#       spanishsl.topics.create!(name: "3.1. Salir y divertirse", time: 3, unit: "Unidad 3")
#       spanishsl.topics.create!(name: "3.1. Punto de verificación", time: 3, unit: "Unidad 3")
#       spanishsl.topics.create!(name: "3.2. Rincón gramatical", time: 1, unit: "Unidad 3")
#       spanishsl.topics.create!(name: "3.2. Fiestas y celebraciones", time: 3, unit: "Unidad 3")
#       spanishsl.topics.create!(name: "3.2. Punto de verificación", time: 3, unit: "Unidad 3")
#       spanishsl.topics.create!(name: "3.3. Rincón gramatical", time: 1, unit: "Unidad 3")
#       spanishsl.topics.create!(name: "3.3. El restaurante", time: 3, unit: "Unidad 3")
#       spanishsl.topics.create!(name: "3.3. Punto de verificación", time: 3, unit: "Unidad 3")
#       spanishsl.topics.create!(name: "3.4. Rincón gramatical", time: 1, unit: "Unidad 3")
#       spanishsl.topics.create!(name: "3.4. Las compras", time: 3, unit: "Unidad 3")
#       spanishsl.topics.create!(name: "3.4. Punto de verificación", time: 3, unit: "Unidad 3")
#       spanishsl.topics.create!(name: "4.1. Rincón gramatical", time: 1, unit: "Unidad 4")
#       spanishsl.topics.create!(name: "4.1. Los problemas de mi ciudad", time: 3, unit: "Unidad 4")
#       spanishsl.topics.create!(name: "4.1. Punto de verificación", time: 3, unit: "Unidad 4")
#       spanishsl.topics.create!(name: "4.2. Rincón gramatical", time: 1, unit: "Unidad 4")
#       spanishsl.topics.create!(name: "4.2. El estado del planeta", time: 3, unit: "Unidad 4")
#       spanishsl.topics.create!(name: "4.2. Punto de verificación", time: 3, unit: "Unidad 4")
#       spanishsl.topics.create!(name: "4.3. Rincón gramatical", time: 1, unit: "Unidad 4")
#       spanishsl.topics.create!(name: "4.3. Recursos naturales", time: 3, unit: "Unidad 4")
#       spanishsl.topics.create!(name: "4.3. Punto de verificación", time: 3, unit: "Unidad 4")
#       spanishsl.topics.create!(name: "4.4. Rincón gramatical", time: 1, unit: "Unidad 4")
#       spanishsl.topics.create!(name: "4.4. Cuidemos el medio ambiente", time: 3, unit: "Unidad 4")
#       spanishsl.topics.create!(name: "4.4. Punto de verificación", time: 3, unit: "Unidad 4")
#       spanishsl.topics.create!(name: "Mock Exam 100%", time: 3, unit: "Mock Exam 100%", milestone: true, has_grade: true, Mock100: true)

#       environmental_mgmt = Subject.create!(
#         name: "Environmental Management IGCSE",
#         category: :igcse,
#         )

#         environmental_mgmt.topics.create!(name: "1.1 Formation of rocks", time: 3, unit: "1. Rocks and minerals and their exploitation")
#         environmental_mgmt.topics.create!(name: "1.2 Extraction of rocks and minerals from the Earth", time: 3, unit: "1. Rocks and minerals and their exploitation")
#         environmental_mgmt.topics.create!(name: "1.3 Impact of rock and mineral extraction", time: 5, unit: "1. Rocks and minerals and their exploitation")
#         environmental_mgmt.topics.create!(name: "1.4 Managing the impact of rock and mineral extraction", time: 2, unit: "1. Rocks and minerals and their exploitation")
#         environmental_mgmt.topics.create!(name: "1.5 Sustainable use of rocks and minerals", time: 6, unit: "1. Rocks and minerals and their exploitation")
#         environmental_mgmt.topics.create!(name: "Checkpoint 1: Rocks and minerals and their exploitation (1.1 - 1.5)", time: 1, unit: "1. Rocks and minerals and their exploitation")
#         environmental_mgmt.topics.create!(name: "2.1 Fossil fuel formation", time: 5, unit: "2. Energy and the environment")
#         environmental_mgmt.topics.create!(name: "2.2 Energy resources and the generation of electricity", time: 4, unit: "2. Energy and the environment")
#         environmental_mgmt.topics.create!(name: "2.3 Energy demand", time: 2, unit: "2. Energy and the environment")
#         environmental_mgmt.topics.create!(name: "2.4 Conservation and management of energy resources", time: 3, unit: "2. Energy and the environment")
#         environmental_mgmt.topics.create!(name: "2.5 Impact of oil pollution", time: 2, unit: "2. Energy and the environment")
#         environmental_mgmt.topics.create!(name: "2.6 Management of oil pollution", time: 5, unit: "2. Energy and the environment")
#         environmental_mgmt.topics.create!(name: "Checkpoint 2: Energy and the environment (2.1 - 2.6)", time: 0.5, unit: "2. Energy and the environment")
#         environmental_mgmt.topics.create!(name: "3.1 Soil composition", time: 2, unit: "3. Agriculture and the environment")
#         environmental_mgmt.topics.create!(name: "3.2 Soils for plant growth", time: 4, unit: "3. Agriculture and the environment")
#         environmental_mgmt.topics.create!(name: "3.3 Agriculture types", time: 3, unit: "3. Agriculture and the environment")
#         environmental_mgmt.topics.create!(name: "3.4 Increasing agricultural yields", time: 3, unit: "3. Agriculture and the environment")
#         environmental_mgmt.topics.create!(name: "3.5 The impact of agriculture", time: 3, unit: "3. Agriculture and the environment")
#         environmental_mgmt.topics.create!(name: "3.6 Causes and impacts of soil erosion", time: 4, unit: "3. Agriculture and the environment")
#         environmental_mgmt.topics.create!(name: "3.7 Managing soil erosion", time: 3, unit: "3. Agriculture and the environment")
#         environmental_mgmt.topics.create!(name: "3.8 Sustainable agriculture", time: 5, unit: "3. Agriculture and the environment")
#         environmental_mgmt.topics.create!(name: "Checkpoint 3: Agriculture and the environment (3.1 - 3.8)", time: 1, unit: "3. Agriculture and the environment")
#         environmental_mgmt.topics.create!(name: "4.1 Global water distribution", time: 2, unit: "4. Water and its management")
#         environmental_mgmt.topics.create!(name: "4.2 The water cycle", time: 5, unit: "4. Water and its management")
#         environmental_mgmt.topics.create!(name: "4.3 Water supply", time: 2, unit: "4. Water and its management")
#         environmental_mgmt.topics.create!(name: "4.4 Water sources and usage", time: 2, unit: "4. Water and its management")
#         environmental_mgmt.topics.create!(name: "4.5 Water quality and availability", time: 2, unit: "4. Water and its management")
#         environmental_mgmt.topics.create!(name: "4.6 Multipurpose dam projects", time: 2, unit: "4. Water and its management")
#         environmental_mgmt.topics.create!(name: "4.7 Sources, impact and management of water pollution", time: 5, unit: "4. Water and its management")
#         environmental_mgmt.topics.create!(name: "4.8 Managing water-related disease", time: 6, unit: "4. Water and its management")
#         environmental_mgmt.topics.create!(name: "Checkpoint 4: Water and its management (4.1 - 4.8)", time: 1, unit: "4. Water and its management")
#         environmental_mgmt.topics.create!(name: "5.1 Oceans as a resource", time: 3, unit: "5. Oceans and fisheries")
#         environmental_mgmt.topics.create!(name: "5.2 World fisheries", time: 5, unit: "5. Oceans and fisheries")
#         environmental_mgmt.topics.create!(name: "5.3 Exploitation of the oceans: impact on fisheries", time: 4, unit: "5. Oceans and fisheries")
#         environmental_mgmt.topics.create!(name: "5.4 Management of the harvesting of marine species", time: 6, unit: "5. Oceans and fisheries")
#         environmental_mgmt.topics.create!(name: "Checkpoint 5: Oceans and fisheries (5.1 - 5.4)", time: 1, unit: "5. Oceans and fisheries")
#         environmental_mgmt.topics.create!(name: "50% Mock exam", time: 2, unit: "50% Mock exam", milestone: true, has_grade: true, Mock50: true)
#         environmental_mgmt.topics.create!(name: "6.1 What is a natural hazard?", time: 5, unit: "6. Managing natural hazards")
#         environmental_mgmt.topics.create!(name: "6.2 Earthquakes and volcanoes", time: 6, unit: "6. Managing natural hazards")
#         environmental_mgmt.topics.create!(name: "6.3 Tropical cyclones", time: 3, unit: "6. Managing natural hazards")
#         environmental_mgmt.topics.create!(name: "6.4 Flooding", time: 3, unit: "6. Managing natural hazards")
#         environmental_mgmt.topics.create!(name: "6.5 Drought", time: 3, unit: "6. Managing natural hazards")
#         environmental_mgmt.topics.create!(name: "6.6 The impacts of natural hazards", time: 3, unit: "6. Managing natural hazards")
#         environmental_mgmt.topics.create!(name: "6.7 Managing the impacts of natural hazards", time: 3, unit: "6. Managing natural hazards")
#         environmental_mgmt.topics.create!(name: "6.8 Opportunities presented by natural hazards", time: 6, unit: "6. Managing natural hazards")
#         environmental_mgmt.topics.create!(name: "Checkpoint 6: Managing natural hazards (6.1 - 6.8)", time: 1, unit: "6. Managing natural hazards")
#         environmental_mgmt.topics.create!(name: "7.1 The atmosphere", time: 5, unit: "7. The atmosphere and human activities")
#         environmental_mgmt.topics.create!(name: "7.2 Atmospheric pollution and its causes", time: 3, unit: "7. The atmosphere and human activities")
#         environmental_mgmt.topics.create!(name: "7.3 Impact of atmospheric pollution", time: 3, unit: "7. The atmosphere and human activities")
#         environmental_mgmt.topics.create!(name: "7.4 Managing atmospheric pollution", time: 5, unit: "7. The atmosphere and human activities")
#         environmental_mgmt.topics.create!(name: "Checkpoint 7: The atmosphere and human activities (7.1 - 7.4)", time: 1, unit: "7. The atmosphere and human activities")
#         environmental_mgmt.topics.create!(name: "8.1 Human population distribution and density", time: 3, unit: "8. Human population")
#         environmental_mgmt.topics.create!(name: "8.2 Changes in population size", time: 5, unit: "8. Human population")
#         environmental_mgmt.topics.create!(name: "8.3 Population structure", time: 3, unit: "8. Human population")
#         environmental_mgmt.topics.create!(name: "8.4 Managing human population size", time: 5, unit: "8. Human population")
#         environmental_mgmt.topics.create!(name: "Checkpoint 8: Human population (8.1 - 8.4)", time: 1, unit: "8. Human population")
#         environmental_mgmt.topics.create!(name: "9.1 Ecosystems", time: 6, unit: "9. Natural ecosystems and human activities")
#         environmental_mgmt.topics.create!(name: "9.2 Ecosystems under threat", time: 6, unit: "9. Natural ecosystems and human activities")
#         environmental_mgmt.topics.create!(name: "9.3 Deforestation", time: 3, unit: "9. Natural ecosystems and human activities")
#         environmental_mgmt.topics.create!(name: "9.4 Managing forests", time: 3, unit: "9. Natural ecosystems and human activities")
#         environmental_mgmt.topics.create!(name: "9.5 Measuring and managing biodiversity", time: 5, unit: "9. Natural ecosystems and human activities")
#         environmental_mgmt.topics.create!(name: "Checkpoint 9: Natural ecosystems and human activities (9.1 - 9.5)", time: 1, unit: "9. Natural ecosystems and human activities")
#         environmental_mgmt.topics.create!(name: "100% Mock exam", time: 2, unit: "100% Mock exam", milestone: true, has_grade: true, Mock100: true)

#   projeto1 = Subject.create!(
#     name: "P1 - Good health and well-being - LWS Y9",
#     category: :lws,
#     )
english_y8 = Subject.create!(
  name: "English - Y8",
  category: :lws8,
  )
maths_y8 = Subject.create!(
  name: "Maths - Y8",
  category: :lws8,
  )
ltr_y8 = Subject.create!(
  name: "Learning Through Research - Y8",
  category: :lws8,
  )

science_y8 = Subject.create!(
  name: "Science - Y8",
  category: :lws8,
  )

portuguese_y8 = Subject.create!(
  name: "Português - Y8",
  category: :lws8,
  )

  portuguese_y8.topics.create!(name: "1.1 Textos dos Media e Quotidiano: A Reportagem", time: 1, unit: "Project 1")
  portuguese_y8.topics.create!(name: "1.1 Vamos gravar uma reportagem? — Let's Check your Understanding!", time: 1, unit: "Project 1")
  portuguese_y8.topics.create!(name: "1.2 Notícia, para que te quero?", time: 1, unit: "Project 1")
  portuguese_y8.topics.create!(name: "1.3 Fake News! Notícias Falsas!", time: 1, unit: "Project 1")
  portuguese_y8.topics.create!(name: "1.3 Reduz a Circulação de Notícias Falsas — Let's Check your Understanding!", time: 1, unit: "Project 1")
  portuguese_y8.topics.create!(name: "2.1 Textos Informativos", time: 1, unit: "Project 2")
  portuguese_y8.topics.create!(name: "2.1 Texto Informativo sobre Imigração em Portugal — Let's Check your Understanding", time: 1, unit: "Project 2")
  portuguese_y8.topics.create!(name: "2.2 Banda Desenhada", time: 1, unit: "Project 2")
  portuguese_y8.topics.create!(name: "2.2 Banda Desenhada — Let's Check your Understanding", time: 1, unit: "Project 2")
  portuguese_y8.topics.create!(name: "2.3 Carta Formal & Informal", time: 1, unit: "Project 2")
  portuguese_y8.topics.create!(name: "2.3 Escreve uma carta formal ✉️ — Let's Check your Understanding", time: 1, unit: "Project 2")
  portuguese_y8.topics.create!(name: "2.4 Chats e Blogs", time: 1, unit: "Project 2")
  portuguese_y8.topics.create!(name: "2.4 Aplicações de Chat — Let's Check your Understanding I", time: 1, unit: "Project 2")
  portuguese_y8.topics.create!(name: "2.4 O meu blog — Let's Check your Understanding", time: 1, unit: "Project 2")
  portuguese_y8.topics.create!(name: "3.1 Textos Narrativos", time: 1, unit: "Project 3")
  portuguese_y8.topics.create!(name: "3.1 Releitura → Let's Check your Understanding", time: 1, unit: "Project 3")
  portuguese_y8.topics.create!(name: "3.2 Lenda", time: 1, unit: "Project 3")
  portuguese_y8.topics.create!(name: "3.2 Lenda → Let's Check your Understanding!", time: 1, unit: "Project 3")
  portuguese_y8.topics.create!(name: "3.3 Conto", time: 1, unit: "Project 3")
  portuguese_y8.topics.create!(name: "3.3 Conto → Let's Check your Understanding", time: 1, unit: "Project 3")
  portuguese_y8.topics.create!(name: "3.4 Fábulas", time: 1, unit: "Project 3")
  portuguese_y8.topics.create!(name: "3.4 Fábula → Let's Check your Understanding!", time: 1, unit: "Project 3")
  portuguese_y8.topics.create!(name: "4.1 Classe de Palavras: Nomes e Adjetivos", time: 1, unit: "Project 4")
  portuguese_y8.topics.create!(name: "4.1.1 Classe de Palavras: Nomes e Adjetivos -  Let's Check your Understanding", time: 1, unit: "Project 4")
  portuguese_y8.topics.create!(name: "4.1.2 Classe de Palavras: Nomes e Adjetivos - Let's Check your Understanding", time: 1, unit: "Project 4")
  portuguese_y8.topics.create!(name: "4.2 Classe de Palavras: Pronomes e Determinantes", time: 1, unit: "Project 4")
  portuguese_y8.topics.create!(name: "4.2 Classe de Palavras: Pronomes e Determinantes - Let's Check your Understanding 1", time: 1, unit: "Project 4")
  portuguese_y8.topics.create!(name: "4.3: Classe de Palavras: Interjeição, Conjunção e Quantificadores", time: 1, unit: "Project 4")
  portuguese_y8.topics.create!(name: "4.3.1 Classe de Palavras: Interjeição, Conjunção e Qualificadores. - Let's Check your Understanding", time: 1, unit: "Project 4")
  portuguese_y8.topics.create!(name: "4.3.2 Classe de Palavras: Interjeição, Conjunção e Quantificadores. - Let's Check your Understanding", time: 1, unit: "Project 4")
  portuguese_y8.topics.create!(name: "4.4 Classe de Palavras: Verbos, Advérbios e Preposições.", time: 1, unit: "Project 4")
  portuguese_y8.topics.create!(name: "4.4 Classe de Palavras: Verbos, Advérbios e Preposições. - Let's Check your Understanding", time: 1, unit: "Project 4")
  portuguese_y8.topics.create!(name: "Português — 50% Progression Test Submission", time: 1, unit: "Project 4", milestone: true, has_grade: true, Mock50: true)
  portuguese_y8.topics.create!(name: "5.1 Biografia", time: 1, unit: "Project 5")
  portuguese_y8.topics.create!(name: "5.1 Let's Check Your Understanding! - Biografia", time: 1, unit: "Project 5")
  portuguese_y8.topics.create!(name: "5.2 Processo de formação de palavras", time: 1, unit: "Project 5")
  portuguese_y8.topics.create!(name: "5.2 Let's Check Your Understanding! - Processo de formação de palavras", time: 1, unit: "Project 5")
  portuguese_y8.topics.create!(name: "5.3 Comparação e Interpretação entre textos.", time: 1, unit: "Project 5")
  portuguese_y8.topics.create!(name: "5.3 Let's Check Your Understanding! - Comparação e Interpretação entre textos.", time: 1, unit: "Project 5")
  portuguese_y8.topics.create!(name: "5.4 Organização textual e sinais de pontuação", time: 1, unit: "Project 5")
  portuguese_y8.topics.create!(name: "5.4.1 Let's Check Your Understanding! - Organização textual e sinais de pontuação", time: 1, unit: "Project 5")
  portuguese_y8.topics.create!(name: "5.4.2 Let's Check Your Understanding! - Organização textual e sinais de pontuação", time: 1, unit: "Project 5")
  portuguese_y8.topics.create!(name: "6.1 Texto poético", time: 1, unit: "Project 6")
  portuguese_y8.topics.create!(name: "6.1.1 Texto poético — Let's Check Your Understanding!", time: 1, unit: "Project 6")
  portuguese_y8.topics.create!(name: "6.1.2 Texto poético — Let's Check Your Understanding!", time: 1, unit: "Project 6")
  portuguese_y8.topics.create!(name: "6.2 Registo e tratamento de informações", time: 1, unit: "Project 6")
  portuguese_y8.topics.create!(name: "6.2.1 Registo e tratamento de informações — Let's Check Your Understanding!", time: 1, unit: "Project 6")
  portuguese_y8.topics.create!(name: "6.2.2 Registo e tratamento de informações — Let's Check Your Understanding!", time: 1, unit: "Project 6")
  portuguese_y8.topics.create!(name: "6.3 Funções sintáticas: Sujeito, vocativo e predicado", time: 1, unit: "Project 6")
  portuguese_y8.topics.create!(name: "6.3 Funções sintáticas: Sujeito, vocativo e predicado — Let's Check Your Understanding!", time: 1, unit: "Project 6")
  portuguese_y8.topics.create!(name: "7.1 Funções sintáticas: Complemento direto", time: 1, unit: "Project 7")
  portuguese_y8.topics.create!(name: "7.1 Let's Check your Understanding!  - Funções sintáticas: Complemento direto", time: 1, unit: "Project 7")
  portuguese_y8.topics.create!(name: "7.2 Funções sintáticas: Complemento indireto e oblíquo", time: 1, unit: "Project 7")
  portuguese_y8.topics.create!(name: "7.2 Let's Check your Understanding! - Funções sintáticas: Complemento indireto e oblíquo", time: 1, unit: "Project 7")
  portuguese_y8.topics.create!(name: "7.3 Funções sintáticas: Complemento agente da passiva", time: 1, unit: "Project 7")
  portuguese_y8.topics.create!(name: "7.3 Let's Check your Understanding! - Funções sintáticas: Complemento agente da passiva e Predicativo de Sujeito", time: 1, unit: "Project 7")
  portuguese_y8.topics.create!(name: "8.1 Predicativo do sujeito", time: 1, unit: "Project 8")
  portuguese_y8.topics.create!(name: "8.1 Let's Check Your Understanding! - Predicativo do sujeito", time: 1, unit: "Project 8")
  portuguese_y8.topics.create!(name: "8.2 Modificadores", time: 1, unit: "Project 8")
  portuguese_y8.topics.create!(name: "8.2 Let's Check Your Understanding! -  Modificadores", time: 1, unit: "Project 8")
  portuguese_y8.topics.create!(name: "8.3 Frase simples e frase complexa", time: 1, unit: "Project 8")
  portuguese_y8.topics.create!(name: "8.3 Let's Check Your Understanding! -  Frase simples e frase complexa", time: 1, unit: "Project 8")
  portuguese_y8.topics.create!(name: "9.1 Artigo de Opinião", time: 1, unit: "Project 9")
  portuguese_y8.topics.create!(name: "9.1 Let's Check your Understanding! - Artigo de Opinião", time: 1, unit: "Project 9")
  portuguese_y8.topics.create!(name: "9.2 O autorretrato", time: 1, unit: "Project 9")
  portuguese_y8.topics.create!(name: "9.2 Let's Check your Understanding! - O autorretrato", time: 1, unit: "Project 9")
  portuguese_y8.topics.create!(name: "Português — 100% Progression Test Submission", time: 1, unit: "Project 9", milestone: true, has_grade: true, Mock100: true)



#       business_up_3 = Subject.create!(
#         name: "Business(UP) - Level 3",
#         category: :up,
#         )

#   business_up_3.topics.create!(name: "Unit 1: The External Influences on a Business", time: 12, unit:"Module 1 - The Business Environment")
#   business_up_3.topics.create!(name: "Unit 2: The Ethics of an Organisation", time: 8, unit:"Module 1 - The Business Environment")
#   business_up_3.topics.create!(name: "Unit 3: Environmental Awareness", time: 12, unit:"Module 1 - The Business Environment")
#   business_up_3.topics.create!(name: "Unit 4: Cultural Impacts", time: 8, unit:"Module 1 - The Business Environment")
#   business_up_3.topics.create!(name: "Unit 5: Sourcing Information", time: 12, unit:"Module 1 - The Business Environment")
#   business_up_3.topics.create!(name: "1.1 Describe the diverse activities carried out in the marketing departments of organisations. (LO1)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "1.2 Explain techniques used in market research including 7Ps. (LO1)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "1.3 Explain how segmentation is used as a tool to identify a target market. (LO1)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "1.4 Explain 3 ethical issues researchers need to consider when undertaking market research. (LO2)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "1.5 Identify 3 pieces of legislation and explain how these can impact market research activities. (LO2)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "2M1 Analyses the impact of failing to act ethically in market research. You should include real business examples and draw conclusions. (LO2)", time: 4, unit:"Task 1")
#   business_up_3.topics.create!(name: "4M1 Analyses the potential difficulties faced when carrying out market research. (LO4)", time: 4, unit:"Task 1")
#   business_up_3.topics.create!(name: "1D1 Compares and contrasts segmentation strategies for 2 SME organisations. (LO1)", time: 6, unit:"Task 1")
#   business_up_3.topics.create!(name: "2.1 Prepare a Market Research Proposal", time: 2, unit:"Task 2")
#   business_up_3.topics.create!(name: "2.2 Prepare a Market Research Plan", time: 2, unit:"Task 2")
#   business_up_3.topics.create!(name: "3.1 & 3.2 Undertake market research in line with the market research plan produced for Task 2 and interpret your market research results. (LO4)", time: 4, unit:"Task 3")
#   business_up_3.topics.create!(name: "4.1 Prepare a Market Research Report", time: 4, unit:"Task 4")
#   business_up_3.topics.create!(name: "5D1 Examine how the market research undertaken in Task 3 can impact both strategic and operational decision-making across organisational functions. (LO4 and 5)", time: 6, unit:"Task 4")
#   business_up_3.topics.create!(name: "5.1 A record of feedback on your research skills obtained from your tutor. (LO6)", time: 2, unit:"Task 5")
#   business_up_3.topics.create!(name: "5.2 A review of your personal research skills. (LO6)", time: 2, unit:"Task 5")
#   business_up_3.topics.create!(name: "5.3 An analysis of the effectiveness of your research skills. (LO6)", time: 2, unit:"Task 5")
#   business_up_3.topics.create!(name: "6M1 Produce a personal development plan to build on the strengths and address the gaps identified in own research skills. (LO6)", time: 4, unit:"Task 5")
#   business_up_3.topics.create!(name: "Unit 6: The Elements of Marketing", time: 8, unit:"Module 1 - The Business Environment")
#   business_up_3.topics.create!(name: "1. Produce a briefing document", time: 16, unit: "Task 1")
#   business_up_3.topics.create!(name: "3M1 Analyse how marketing and sales strategies change during a product’s life cycle. (LO2)", time: 4, unit:"Task 1")
#   business_up_3.topics.create!(name: "4M1 Analyse the importance of physical evidence, people and process for a named service. (LO4)", time: 4, unit:"Task 1")
#   business_up_3.topics.create!(name: "2. Produce a report", time: 4, unit:"Task 2")
#   business_up_3.topics.create!(name: "5D1 Develop a marketing mix plan for a relevant FDL product or service. (LO2, 3, 4 and 5)", time: 6, unit:"Task 2")
#   business_up_3.topics.create!(name: "Unit 1: The Decision Making Process", time: 12, unit:"Module 2: Managing Business Operations")
#   business_up_3.topics.create!(name: "Unit 2: The Structure of Organisations", time: 8, unit:"Module 2: Managing Business Operations")
#   business_up_3.topics.create!(name: "1.1 Identify the stakeholders for a named, profit making, organisation and explain their interests, objectives and potential conflicts. (LO1)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "1.2 1.2 Explain the interests and objectives of stakeholders in a named organisation operating in the not- for-profit sector. (LO1)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "2.1 Describe economic sectors and the output generated from each sector. (LO2)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "2.2 Analyse the size and importance of these sectors in a named country. (LO2)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "3.1 Conduct a STEEPLE analysis to show how the external environment impacts a named organisation. (LO3)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "4.1 Explain how the nature of work and employment have changed globally in recent year. (LO4)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "2M1 Analyse recent changes seen in economic sectors in a named country. (LO2)", time: 4, unit:"Task 1")
#   business_up_3.topics.create!(name: "4M1 Analyse the implications of the changes to working patterns for organisations and individuals. (LO4)", time: 4, unit:"Task 1")
#   business_up_3.topics.create!(name: "4D1 Evaluate the impact of technology on the organisation and individuals. (LO 3 & 4)", time: 6, unit:"Task 1")
#   business_up_3.topics.create!(name: "Unit 3: The Skills of Planning (Part A)", time: 4, unit:"Module 2: Managing Business Operations")
#   business_up_3.topics.create!(name: "Unit 4: The Planning Process (Part B)", time: 8, unit:"Module 2: Managing Business Operations")
#   business_up_3.topics.create!(name: "Unit 5: Controlling Operations", time: 4, unit:"Module 2: Managing Business Operations")
#   business_up_3.topics.create!(name: "Unit 6: Financial Stewardship & Budgeting (Part A)", time: 8, unit:"Module 2: Managing Business Operations")
#   business_up_3.topics.create!(name: "Unit 7: Financial Stewardship & Budgeting (Part B) Financial Decision Making", time: 8, unit:"Module 2: Managing Business Operations")
#   business_up_3.topics.create!(name: "1.1 Explain the following terms:", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "1.2 Explain the concept of contribution and the significance of the breakeven level of output. (LO1)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "2.1 Using the information in the workbook, construct a simple budget. (LO2)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "2.2 Explain how budgets are monitored using budget variance analysis and (b) the benefits of an effective budgetary control process. (LO2)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "3.1 MML is considering buying another fruit shop, whose owner is looking to retire. Using the figures given in the workbook, calculate", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "3.2 Analyse the possible reasons for the results from 3.2. (LO3)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "4.1 Explain the differences between cash and profit. (LO4)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "4.2 Using the figures given in the workbook, construct a cash flow statement. (LO4)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "4.3 Analyse the importance to a business of managing cash flow. (LO4)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "1M1 Analyse the relationship between price and the breakeven level of output. (LO1)", time: 4, unit:"Task 1")
#   business_up_3.topics.create!(name: "2M1 Using the information provided in the workbook, Analyse the reasons why variances can occur in a budget (LO2)", time: 4, unit:"Task 1")
#   business_up_3.topics.create!(name: "3M1 Analyse ways businesses can improve their financial ratios. (LO3)", time: 4, unit:"Task 1")
#   business_up_3.topics.create!(name: "4D1 Evaluate the impact of budgetary and cash flow control on one business function. (LO 2 & 4)", time: 6, unit:"Task 1")
#   business_up_3.topics.create!(name: "Unit 8: Putting Customers First", time: 8, unit:"Module 2: Managing Business Operations")
#   business_up_3.topics.create!(name: "Unit 1: The Importance of Resources to Business Success", time: 8, unit:"Module 3: Maximising Resources to Achieve Business Success")
#   business_up_3.topics.create!(name: "Unit 2: How Organisations Monitor the Use of Resources", time: 12, unit:"Module 3: Maximising Resources to Achieve Business Success")
#   business_up_3.topics.create!(name: "Unit 3: Harnessing Technology", time: 16, unit:"Module 3: Maximising Resources to Achieve Business Success")
#   business_up_3.topics.create!(name: "1.1 Outline the differences between strategic, tactical and operational objectives. Give an example for each objective. (LO1)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "1.2 Explain factors that lead to the choice of objectives in both profit and non-profit making organisations. (LO1)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "2.1 Explain the importance of customers and customer service to organisations. (LO2)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "3.1 Analyse different organisational structures and legal identities of businesses. (LO3)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "4.1 Select an organisation and analyse the importance of human resources to the organisation. (LO4)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "4.2 Explain the physical and digital/technological resources as well as the sources of finance required by this organisation. (LO4)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "5.1 Explain the main components of", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "5.2 Explain the elements and purpose of budgets. (LO5)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "1M1 Assess the factors that lead to organisations changing objectives. (LO1)", time: 4, unit:"Task 1")
#   business_up_3.topics.create!(name: "2M1 Evaluate how effective customer service is achieved for online customers. (LO2)", time: 4, unit:"Task 1")
#   business_up_3.topics.create!(name: "4D1 Compare and contrast the resource requirements for a named sole trader and a named limited company. (LO 3 & 4)", time: 6, unit:"Task 1")
#   business_up_3.topics.create!(name: "Unit 4: Project Management", time: 12, unit:"Module 3: Maximising Resources to Achieve Business Success")
#   business_up_3.topics.create!(name: "Unit 5: Best Practice & Sound Policy", time: 12, unit:"Module 3: Maximising Resources to Achieve Business Success")
#   business_up_3.topics.create!(name: "1.1 Explain the role of the HR function. (LO1)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "1.2 Outline key legislation impacting the HR function in a named country. (LO1)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "2.1 Explain the steps needed for effective recruitment and selection of employees. (LO2)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "2.2 Explain how HR manages the termination of employee contracts including the use of disciplinary procedures. (LO2)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "1M1 Analyse the relationship of HR with other organisational functions. (LO1)", time: 4, unit:"Task 1")
#   business_up_3.topics.create!(name: "2D1 Evaluate the impact of employment legislation on the recruitment and selection process in named country. (LO1 and LO2)", time: 4, unit:"Task 1")
#   business_up_3.topics.create!(name: "1. Create a guide", time: 6, unit:"Task 2")
#   business_up_3.topics.create!(name: "3M1 Analyse the issues HR faces when supporting employees working remotely. (LO3)", time: 4, unit:"Task 2")
#   business_up_3.topics.create!(name: "3D1 Analyse how a named organisation manages workplace stress. (LO3)", time: 6, unit:"Task 2")
#   business_up_3.topics.create!(name: "1. Prepare a presentation", time: 4, unit:"Task 3")
#   business_up_3.topics.create!(name: "4M1 Evaluate approaches to monitoring employee performance in a named organisation. (LO4)", time: 4, unit:"Task 3")
#   business_up_3.topics.create!(name: "Unit 1: Verbal Communication", time: 16, unit:"Module 4: Effective Business Communication")
#   business_up_3.topics.create!(name: "Unit 2: Written Communication", time: 4, unit:"Module 4: Effective Business Communication")
#   business_up_3.topics.create!(name: "Unit 3: Non-verbal Communication", time: 12, unit:"Module 4: Effective Business Communication")
#   business_up_3.topics.create!(name: "Unit 4: Effective Meetings", time: 8, unit:"Module 4: Effective Business Communication")
#   business_up_3.topics.create!(name: "Unit 5: Effective Presentation", time: 12, unit:"Module 4: Effective Business Communication")
#   business_up_3.topics.create!(name: "Unit 6: Dealing With Problems", time: 8, unit:"Module 4: Effective Business Communication")
#   business_up_3.topics.create!(name: "1. Deliver a 10 min presentation", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "1.1 Explain channels of communication used a) internally and b) externally in organisations. (LO1)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "1.2 Explain barriers to communication for organisations looking to expand overseas. You should refer to at least 2 organisations with which you are familiar. (LO1)", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "2M1 Managed a question-and-answer session to demonstrate subject knowledge and communication skills.", time: 4, unit:"Task 1")
#   business_up_3.topics.create!(name: "1. Deliver a 10 min presentation", time: 2, unit:"Task 2")
#   business_up_3.topics.create!(name: "1.1 Explain channels of communication used a) internally and b) externally in organisations. (LO1)", time: 2, unit:"Task 2")
#   business_up_3.topics.create!(name: "1.2 Explain barriers to communication for organisations looking to expand overseas. You should refer to at least 2 organisations with which you are familiar. (LO1)", time: 2, unit:"Task 2")
#   business_up_3.topics.create!(name: "2M1 Managed a question-and-answer session to demonstrate subject knowledge and communication skills.", time: 4, unit:"Task 2")
#   business_up_3.topics.create!(name: "Prepare a formal business report", time: 4, unit:"Task 3")
#   business_up_3.topics.create!(name: "3M1 Add a further section in your report to propose and justify solutions to the complaints listed above from customers at Verto. (LO3)", time: 4, unit:"Task 3")
#   business_up_3.topics.create!(name: "3.1 Obtained feedback on your communication skills. (LO4)", time: 2, unit:"Task 4")
#   business_up_3.topics.create!(name: "3.2 Completed a personal reflection on your communication skills. (LO4)", time: 2, unit:"Task 4")
#   business_up_3.topics.create!(name: "4D1 Produce a plan to improve personal communication skills. Your plan must include SMART targets and opportunities for monitoring and reviewing the plan. (LO 3 & 4)", time: 6, unit:"Task 4")
#   business_up_3.topics.create!(name: "Unit 1: Recruiting the Right People", time: 12, unit:"Module 5: Managing People in Organisations")
#   business_up_3.topics.create!(name: "Unit 2: Managing Performance", time: 8, unit:"Module 5: Managing People in Organisations")
#   business_up_3.topics.create!(name: "Unit 3: Developing People", time: 8, unit:"Module 5: Managing People in Organisations")
#   business_up_3.topics.create!(name: "Unit 4: Making Training Work", time: 12, unit:"Module 5: Managing People in Organisations")
#   business_up_3.topics.create!(name: "Unit 5: Improving Personal Effectiveness", time: 8, unit:"Module 5: Managing People in Organisations")
#   business_up_3.topics.create!(name: "Unit 6: Workplace Welfare", time: 8, unit:"Module 5: Managing People in Organisations")
#   business_up_3.topics.create!(name: "Unit 7: Managing Change", time: 8, unit:"Module 5: Managing People in Organisations")
#   business_up_3.topics.create!(name: "Unit 1: Effective Teams", time: 8, unit:"Module 6")
#   business_up_3.topics.create!(name: "Unit 2: The Art of Leadership", time: 8, unit:"Module 6")
#   business_up_3.topics.create!(name: "Handout 1", time: 10, unit:"Task 1")
#   business_up_3.topics.create!(name: "Handout 2", time: 2, unit:"Task 1")
#   business_up_3.topics.create!(name: "2M1 Evaluate how one motivational theory is used in organisations to improve productivity. (LO2)", time: 4, unit:"Task 1")
#   business_up_3.topics.create!(name: "4D1 Analyse the leadership style required for a specific team leader in a named organisation. (LO 2 & 3)", time: 6, unit:"Task 1")
#   business_up_3.topics.create!(name: "1. Carry out a personal skills audit, using evidence from your work, team work or other commitments to justify your strengths and areas for development. (LO4)", time: 2, unit:"Task 2")
#   business_up_3.topics.create!(name: "2. Select an advertisement for a job to which you aspire and compile a personal CV with an accompanying covering letter for the role. (LO4)", time: 2, unit:"Task 2")
#   business_up_3.topics.create!(name: "4M1 Construct an action plan for developing skills that you identify as requiring further improvement. (LO4)", time: 4, unit:"Task 2")
#   business_up_3.topics.create!(name: "Unit 3: Motivating People", time: 8, unit:"Module 6")
#   business_up_3.topics.create!(name: "Unit 4: Effective Delegation", time: 8, unit:"Module 6")
#   business_up_3.topics.create!(name: "Unit 5: Influencing Skills", time: 12, unit:"Module 6")
#   business_up_3.topics.create!(name: "Unit 6: Building Interpersonal Relationships", time: 8, unit:"Module 6")
#   business_up_3.topics.create!(name: "Unit 7: Handling People Conflict", time: 8, unit:"Module 6")
#   business_up_3.topics.create!(name: "1.1 Explain the difference between management and leadership making reference to the key skills and qualities of effective leaders and managers (LO1)", time: 2, unit:"Task 3")
#   business_up_3.topics.create!(name: "1.2 Outline the difference between delegation and abdication of responsibility (LO1)", time: 2, unit:"Task 3")
#   business_up_3.topics.create!(name: "2.1 Outline key management and leadership theories. (LO2)", time: 2, unit:"Task 3")
#   business_up_3.topics.create!(name: "2.2 Outline key employee performance indicators used by employers. (LO2)", time: 2, unit:"Task 3")
#   business_up_3.topics.create!(name: "2.3 Explain how employee conflict can be managed. (LO2)", time: 2, unit:"Task 3")
#   business_up_3.topics.create!(name: "3.1 Explain leadership and management approaches to developing employee strengths (LO3)", time: 2, unit:"Task 3")
#   business_up_3.topics.create!(name: "3.2 Explain how leaders and managers support employees working a) remotely b) in teams (LO3)", time: 2, unit:"Task 3")
#   business_up_3.topics.create!(name: "4.1 Explain key motivation theories. (LO4)", time: 2, unit:"Task 3")
#   business_up_3.topics.create!(name: "3M1 Analyse how either a manager or leader supports employees in a named organisation. (LO3)", time: 4, unit:"Task 3")
#   business_up_3.topics.create!(name: "3D1 Analyse the potential impact of ineffective leadership and management on employees and the organisation. (LO2 and 3)", time: 6, unit:"Task 3")
#   business_up_3.topics.create!(name: "4D1 Evaluate how employees are motivated in a named organisation. (LO4)", time: 6, unit:"Task 3")
#   business_up_3.topics.create!(name: "5.1 Obtain feedback on your leadership and management skills from others. (LO5)", time: 2, unit:"Task 4")
#   business_up_3.topics.create!(name: "5.2 Analyse your personal leadership and management skills using the feedback. (LO5)", time: 2, unit:"Task 4")
#   business_up_3.topics.create!(name: "5M1 Produce a plan to develop leadership skills identified as requiring improvement. (LO5)", time: 4, unit:"Task 4")

#   business_up_4 = Subject.create!(
#     name: "Business(UP) - Level 4",
#     category: :up,
#     )

# business_up_4.topics.create!(name: "Unit 1: External Influences on Business", time: 8, unit:"Module 1")
# business_up_4.topics.create!(name: "Unit 2: Markets, Demand, & Supply.", time: 8, unit:"Module 1")
# business_up_4.topics.create!(name: "Unit 3: Types of Organisations", time: 4, unit:"Module 1")
# business_up_4.topics.create!(name: "Unit 4: Decision Making & Planning", time: 4, unit:"Module 1")
# business_up_4.topics.create!(name: "Unit 5: Different Organisational Structures", time: 8, unit:"Module 1")
# business_up_4.topics.create!(name: "Unit 6: The National Environment", time: 8, unit:"Module 1")
# business_up_4.topics.create!(name: "Pass - Prepare a presentation with supporting notes and a handout", time: 12, unit:"Task 1")
# business_up_4.topics.create!(name: "Merit - Analyse the extent to which a specific organisation meets its stated purposes.", time: 6, unit:"Task 1")
# business_up_4.topics.create!(name: "Pass - Write a discussion paper", time: 4, unit:"Task 2")
# business_up_4.topics.create!(name: "Pass - Prepare short case studies", time: 4, unit:"Task 2")
# business_up_4.topics.create!(name: "Pass - Write an article", time: 4, unit:"Task 2")
# business_up_4.topics.create!(name: "Distinction - To achieve a Distinction, your handout package must include assessment of the organisational structure of a selected existing organisation", time: 6, unit:"Task 2")
# business_up_4.topics.create!(name: "Pass - Prepare a written paper", time: 12, unit:"Task 3")
# business_up_4.topics.create!(name: "Merit - To achieve a Merit, your paper must include an assessment of the response of a selected organisation to changes in its market.", time: 6, unit:"Task 3")
# business_up_4.topics.create!(name: "Pass - Prepare a leaflet", time: 12, unit:"Task 4")
# business_up_4.topics.create!(name: "Distinction - To achieve a Distinction, your leaflet must include a case study which compares and contrasts the benefits and challenges to a specific business operating in different economic environments.", time: 6, unit:"Task 4")
# business_up_4.topics.create!(name: "Unit 1: Financial & Management Accounting Systems", time: 16, unit:"Module 2")
# business_up_4.topics.create!(name: "Unit 2: Assessing Business Performance", time: 4, unit:"Module 2")
# business_up_4.topics.create!(name: "Unit 3: Management Accounting Techniques", time: 12, unit:"Module 2")
# business_up_4.topics.create!(name: "Pass - Prepare a leaflet", time: 8, unit:"Task 1")
# business_up_4.topics.create!(name: "Merit - To achieve a Merit your leaflet must evaluate the benefits of financial and management accounting systems for a specific business organisation", time: 6, unit:"Task 1")
# business_up_4.topics.create!(name: "Distinction - To achieve a Distinction your leaflet must evaluate how a specific business organisation integrates financial and management accounting systems into their organisational processes.", time: 6, unit:"Task 1")
# business_up_4.topics.create!(name: "Pass - Produce a draft paper", time: 4, unit:"Task 2")
# business_up_4.topics.create!(name: "Pass - Produce a paper", time: 12, unit:"Task 3")
# business_up_4.topics.create!(name: "Merit - To achieve a Merit your paper must also evaluate the usefulness of ratio analysis when assessing organisational performance", time: 6, unit:"Task 3")
# business_up_4.topics.create!(name: "Pass - a) Using appropriate project appraisal techniques assess and demonstrate the financial viability of each project", time: 2, unit:"Task 4")
# business_up_4.topics.create!(name: "Pass - b) Evaluate the methods of investment appraisal completed in part (a). Recommend the most appropriate priject for the business.", time: 2, unit:"Task 4")
# business_up_4.topics.create!(name: "Distinction - To achieve a Distinction your written work must also evaluate the benefits of management accounting techniques in supporting financial decision making to ensure long term financial stability.", time: 6, unit:"Task 4")
# business_up_4.topics.create!(name: "a)  Calculate the total and unit costs of the finished product.", time: 4, unit:"Task 5")
# business_up_4.topics.create!(name: "b)  Produce an absorption costing statement showing the marginal cost.", time: 0, unit:"Task 5")
# business_up_4.topics.create!(name: "c)  Calculate the materials, labour and overhead variances.", time: 0, unit:"Task 5")
# business_up_4.topics.create!(name: "d)  Interpret the variance results considering both financial and non-financial factors.", time: 2, unit:"Task 5")
# business_up_4.topics.create!(name: "e)  Evaluate the use of different costing methods for pricing purposes", time: 2, unit:"Task 5")
# business_up_4.topics.create!(name: "Unit 1: What Is Operations Management?", time: 12, unit:"Module 3")
# business_up_4.topics.create!(name: "Unit 2: The Relationship Between Operations and Performance", time: 16, unit:"Module 3")
# business_up_4.topics.create!(name: "Unit 3: Techniques to Make Operational Management Decisions", time: 8, unit:"Module 3")
# business_up_4.topics.create!(name: "Pass - Prepare a paper", time: 12, unit:"Task 1")
# business_up_4.topics.create!(name: "Pass - Produce detailed notes", time: 8, unit:"Task 2")
# business_up_4.topics.create!(name: "Merit - To achieve a Merit your notes must also include an assessment of the significance of performance objectives which underpin operations management.", time: 6, unit:"Task 2")
# business_up_4.topics.create!(name: "Distinction - To achieve a Distinction you must provide an example from a stated organisation for the team to scrutinise. Using a process model evaluate of how the organisation manages its operations", time: 6, unit:"Task 2")
# business_up_4.topics.create!(name: "Pass - Prepare a document", time: 8, unit:"Task 3")
# business_up_4.topics.create!(name: "Pass - Prepare detailed notes", time: 4, unit:"Task 3")
# business_up_4.topics.create!(name: "Merit - To achieve a Merit your preparation for the meeting must also include an analysis of the processes and systems used to review the implementation of operations management in a specific organisation", time: 6, unit:"Task 3")
# business_up_4.topics.create!(name: "Distinction - To achieve a Distinction your work must include a justification of the use of critical path analysis when making operations management decisions in a named organisation.", time: 6, unit:"Task 3")
# business_up_4.topics.create!(name: "Unit 1: Business Communication", time: 8, unit:"Module 4")
# business_up_4.topics.create!(name: "Unit 2: Communicating with Customers", time: 12, unit:"Module 4")
# business_up_4.topics.create!(name: "Unit 3: Effective Communication in Business", time: 16, unit:"Module 4")
# business_up_4.topics.create!(name: "Unit 4: Presenting Oral Information", time: 16, unit:"Module 4")
# business_up_4.topics.create!(name: "Unit 5: Written Communication", time: 12, unit:"Module 4")
# business_up_4.topics.create!(name: "Pass - Prepare a formal report. You will need to use charts and graphs to present information as appropriate to convey quantitative data", time: 24, unit:"Task 1")
# business_up_4.topics.create!(name: "Merit - Provide guidance for SHDE, using examples of best practice from other organisations.", time: 12, unit:"Task 1")
# business_up_4.topics.create!(name: "Pass - Design an oral presentation with supporting notes", time: 20, unit:"Task 2")
# business_up_4.topics.create!(name: "Distinction - Adapt your presentation materials to provide a summary to the Senior Management team – members need to know your key messages and the implications for the business.", time: 6, unit:"Task 2")
# business_up_4.topics.create!(name: "Pass - Using appropriate technology, please deliver your presentation", time: 4, unit:"Task 3")
# business_up_4.topics.create!(name: "Distinction - Please deliver your adapted presentation to the Senior Management Team in the form of a paper for their next meeting", time: 6, unit:"Task 3")
# business_up_4.topics.create!(name: "a)  Assess the effectiveness of your oral presentation skills", time: 4, unit:"Task 4")
# business_up_4.topics.create!(name: "b)  Review your own written communication including the conventions you have used bringing a paper on these subjects to the meeting.", time: 8, unit:"Task 4")
# business_up_4.topics.create!(name: "c)  Assess the impact of technology on both oral and written communications bringing a paper to the meeting", time: 4, unit:"Task 4")
# business_up_4.topics.create!(name: "d)  Following our discussions, I wish you to produce notes of the meeting which accurately reflect our conversation", time: 4, unit:"Task 4")
# business_up_4.topics.create!(name: "Unit 1: Corporate Social Responsibility Issues", time: 12, unit:"Module 5 - Corporate Social Responsibility")
# business_up_4.topics.create!(name: "Unit 2: The Impact of Corporate Social Responsibility", time: 8, unit:"Module 5 - Corporate Social Responsibility")
# business_up_4.topics.create!(name: "Unit 3: Responsible Business Practice", time: 12, unit:"Module 5 - Corporate Social Responsibility")
# business_up_4.topics.create!(name: "Pass - Produce an explanatory report", time: 12, unit:"Task 1")
# business_up_4.topics.create!(name: "Merit - To achieve a Merit, you must add a section to your report where you assess changing attitudes to CSR", time: 6, unit:"Task 1")
# business_up_4.topics.create!(name: "Distinction - To achieve a Distinction, you must add a section to your report where you evaluate the success of a chosen organisation in managing CSR issues. This may be an organisation which you have worked for, or one that you can research.", time: 6, unit:"Task 1")
# business_up_4.topics.create!(name: "Pass - Prepare discussion notes in the form of detailed information.", time: 12, unit:"Task 2")
# business_up_4.topics.create!(name: "Merit - To achieve a Merit, you must add a section to your discussion notes where you assess the potential conflicts which may arise when we try to satisfy the needs and expectations of different stakeholders through our CSR policy.", time: 6, unit:"Task 2")
# business_up_4.topics.create!(name: "Pass - Draft a brief", time: 12, unit:"Task 3")
# business_up_4.topics.create!(name: "Distinction - To achieve a Distinction, you must add a section to your brief where you assess the extent of voluntarism in CSR policies", time: 6, unit:"Task 3")
# business_up_4.topics.create!(name: "Unit 1: Communication Practices", time: 12, unit:"Module 6 - People in Organisations")
# business_up_4.topics.create!(name: "Unit 2: Effective Teamwork", time: 16, unit:"Module 6 - People in Organisations")
# business_up_4.topics.create!(name: "Unit 3: Remote Working", time: 8, unit:"Module 6 - People in Organisations")
# business_up_4.topics.create!(name: "Unit 4: Monitoring and Supporting People in the Workplace", time: 20, unit:"Module 6 - People in Organisations")
# business_up_4.topics.create!(name: "Report Section A - Communication practices", time: 16, unit:"Write a report")
# business_up_4.topics.create!(name: "Merit - An analysis of the impact new technologies have on organisations’ communications systems and practices", time: 6, unit:"Write a report")
# business_up_4.topics.create!(name: "Report Section B - Teamwork", time: 8, unit:"Write a report")
# business_up_4.topics.create!(name: "Merit - An evaluation of the impact of leadership styles on teamwork", time: 6, unit:"Write a report")
# business_up_4.topics.create!(name: "Distinction - An analysis of the application and effectiveness of teamwork in a given organisation", time: 6, unit:"Write a report")
# business_up_4.topics.create!(name: "Report Section C - Remote working", time: 12, unit:"Write a report")
# business_up_4.topics.create!(name: "Report Section D - Support and monitoring structures", time: 8, unit:"Write a report")
# business_up_4.topics.create!(name: "Distinction - An evaluation of the impact of legislation on employee relations management in different organisational contexts", time: 6, unit:"Write a report")
# business_up_4.topics.create!(name: "Unit 1: Product in the Marketing Mix", time: 12, unit:"Module 7 The Marketing Mix")
# business_up_4.topics.create!(name: "Unit 2: Price in the Marketing Mix", time: 8, unit:"Module 7 The Marketing Mix")
# business_up_4.topics.create!(name: "Unit 3: Place in the Marketing Mix", time: 12, unit:"Module 7 The Marketing Mix")
# business_up_4.topics.create!(name: "Pass - Write a detailed paper", time: 16, unit:"Task 1")
# business_up_4.topics.create!(name: "Merit - An analysis of how a business can create lifetime value to the customer by using the Customer Life Cycle", time: 6, unit:"Task 1")
# business_up_4.topics.create!(name: "Merit - An explanation of the advantages of using a direct marketing channel.", time: 6, unit:"Task 1")
# business_up_4.topics.create!(name: "Distinction - choose an organisation which you have researched or have experience of, and additionally include in the paper:", time: 6, unit:"Task 1")
# business_up_4.topics.create!(name: "Pass - Prepare a presentation with an accompanying handout.", time: 8, unit:"Task 2")
# business_up_4.topics.create!(name: "Merit - To achieve a Merit, you should analyse the effects of adjusting the price of a product or service. Shakti has asked that you include diagrammatic information in your analysis.", time: 6, unit:"Task 2")
# business_up_4.topics.create!(name: "Distinction - To achieve a Distinction, you must choose an organisation which you have researched or have experience of, and additionally include in the presentation and handout an evaluation of the role of price in that organisation’s marketing mix", time: 6, unit:"Task 2")
# business_up_4.topics.create!(name: "Pass - Produce a paper", time: 8, unit:"Task 3")
# business_up_4.topics.create!(name: "Merit - To achieve a Merit, you must include in the same paper an explanation of how promotional activities are regulated. You may use your own country or state", time: 6, unit:"Task 3")
# business_up_4.topics.create!(name: "Distinction - To achieve a Distinction, you must choose an organisation which you have researched or have experience of, and additionally include in the presentation and handout an evaluation of the role of promotion in that organisation’s marketing mix", time: 6, unit:"Task 3")
# business_up_4.topics.create!(name: "Pass - Produce a factsheet", time: 8, unit:"Task 3")
# business_up_4.topics.create!(name: "Merit - To achieve a Merit, you must include in the factsheet an evaluation of the use of Customer Relationship Management in businesses.", time: 6, unit:"Task 3")
# business_up_4.topics.create!(name: "Distinction - To achieve a Distinction, you must choose an organisation which you have researched or have experience of and include in the factsheet an evaluation of the role of people in that organisation’s marketing mix.", time: 6, unit:"Task 3")
# business_up_4.topics.create!(name: "Pass - Prepare a briefing paper", time: 16, unit:"Task 4")
# business_up_4.topics.create!(name: "Distinction - To achieve a Distinction, you must choose an organisation which you have researched or have experience of.", time: 12, unit:"Task 4")
# business_up_4.topics.create!(name: "Unit 1: Entrepreneurship in Business", time: 12, unit:"Module 8 Entrepreneurship")
# business_up_4.topics.create!(name: "Unit 2: Entrepreneurial Skills and Qualities", time: 4, unit:"Module 8 Entrepreneurship")
# business_up_4.topics.create!(name: "Unit 3: New Entrepreneurial Ideas", time: 12, unit:"Module 8 Entrepreneurship")
# business_up_4.topics.create!(name: "Pass - Write a paper", time: 8, unit:"Task 1")
# business_up_4.topics.create!(name: "Merit - An analysis of the impact of entrepreneurship on the economy", time: 6, unit:"Task 1")
# business_up_4.topics.create!(name: "Pass - Prepare a presentation with a handout containing supporting notes for the group on the skills and qualities of an entrepreneur.", time: 8, unit:"Task 2")
# business_up_4.topics.create!(name: "Pass - Write a proposal in which you explain a range of new entrepreneurial ideas and give reasons for why you believe they will succeed.", time: 8, unit:"Task 3")
# business_up_4.topics.create!(name: "Distinction - To achieve a Distinction, you must add to the proposal by further developing the most workable business idea into a workable business venture, justifying your choice", time: 0, unit:"Task 3")
# business_up_4.topics.create!(name: "Pass - Prepare a briefing paper about your preparations for a new business venture, which you will discuss with the group.", time: 4, unit:"Task 4")
# business_up_4.topics.create!(name: "Merit - To achieve a Merit, you must additionally include in the briefing paper an analysis of the brand development and promotion aspects of launching an effective new business venture", time: 6, unit:"Task 4")
# business_up_4.topics.create!(name: "Distinction - To achieve a Distinction, you must additionally develop a start-up plan for your chosen new business venture.", time: 6, unit:"Task 4")
# business_up_4.topics.create!(name: "Unit 7: Managing Change", time: 8, unit:"Task 4")

# business_up_5 = Subject.create!(
#   name: "Business(UP) - Level 5",
#   category: :up,
#   )

# business_up_5.topics.create!(name: "1.1 Global Organisations - Global Businesses", time: 8, unit:"Module 1 - Business Organisations in a Global Context")
# business_up_5.topics.create!(name: "1.2 Global Organisations - Responsibilities", time: 12, unit:"Module 1 - Business Organisations in a Global Context")
# business_up_5.topics.create!(name: "1.3 Global Organisations - Global Business Strategies", time: 12, unit:"Module 1 - Business Organisations in a Global Context")
# business_up_5.topics.create!(name: "1.4 The Impact of External Factors - External Factors", time: 8, unit:"Module 1 - Business Organisations in a Global Context")
# business_up_5.topics.create!(name: "1.5 The Impact of External Factors - Government", time: 8, unit:"Module 1 - Business Organisations in a Global Context")
# business_up_5.topics.create!(name: "1.6 The Impact of Globalisation - Intro", time: 4, unit:"Module 1 - Business Organisations in a Global Context")
# business_up_5.topics.create!(name: "1.7 The Impact of Globalisation - Leadership", time: 12, unit:"Module 1 - Business Organisations in a Global Context")
# business_up_5.topics.create!(name: "1.8 Issues Impacting on Global Businesses - Studying", time: 12, unit:"Module 1 - Business Organisations in a Global Context")
# business_up_5.topics.create!(name: "Pass - Prepare a draft presentation and speaker notes", time: 24, unit:"Task 1")
# business_up_5.topics.create!(name: "Pass - Prepare an information brief", time: 8, unit:"Task 2")
# business_up_5.topics.create!(name: "Merit - Add to the brief", time: 6, unit:"Task 2")
# business_up_5.topics.create!(name: "Distinction - Add to the brief", time: 6, unit:"Task 2")
# business_up_5.topics.create!(name: "Pass- produce a case study booklet", time: 4, unit:"Task 3")
# business_up_5.topics.create!(name: "Merit - Add to the booklet", time: 6, unit:"Task 3")
# business_up_5.topics.create!(name: "Distinction - Add to the booklet", time: 6, unit:"Task 3")
# business_up_5.topics.create!(name: "2.1 Sources of Finance", time: 16, unit:"Module 2 - Finance for Managers")
# business_up_5.topics.create!(name: "2.2 Financial Performance", time: 20, unit:"Module 2 - Finance for Managers")
# business_up_5.topics.create!(name: "2.3 Costing", time: 20, unit:"Module 2 - Finance for Managers")
# business_up_5.topics.create!(name: "Pass - Prepare a business report in a training file.", time: 12, unit:"Task 1")
# business_up_5.topics.create!(name: "Distinction - Add to the report", time: 6, unit:"Task 1")
# business_up_5.topics.create!(name: "Pass - Add a section to the training file", time: 8, unit:"Task 2")
# business_up_5.topics.create!(name: "Merit - Add to the training file", time: 6, unit:"Task 2")
# business_up_5.topics.create!(name: "Distinction - Add to the training file", time: 6, unit:"Task 2")
# business_up_5.topics.create!(name: "Pass- Prepare a presentation with accompanying speaker notes", time: 12, unit:"Task 3")
# business_up_5.topics.create!(name: "3.1 The Operations Function", time: 8, unit:"Module 3 - Operations Management")
# business_up_5.topics.create!(name: "3.2 The Operations Manager", time: 8, unit:"Module 3 - Operations Management")
# business_up_5.topics.create!(name: "3.3 Operational Management vs. Organisation Strategy", time: 12, unit:"Module 3 - Operations Management")
# business_up_5.topics.create!(name: "3.4 Operational Management Contribution to Success", time: 8, unit:"Module 3 - Operations Management")
# business_up_5.topics.create!(name: "3.5 Customer Satisfaction", time: 4, unit:"Module 3 - Operations Management")
# business_up_5.topics.create!(name: "3.6 Operations Quality Measurements", time: 4, unit:"Module 3 - Operations Management")
# business_up_5.topics.create!(name: "3.7 Operations Performance Measurements", time: 8, unit:"Module 3 - Operations Management")
# business_up_5.topics.create!(name: "3.8 Management Frameworks", time: 8, unit:"Module 3 - Operations Management")
# business_up_5.topics.create!(name: "3.9 Ethics", time: 12, unit:"Module 3 - Operations Management")
# business_up_5.topics.create!(name: "Pass - Prepare presentation material including supporting notes", time: 8, unit:"Task 1")
# business_up_5.topics.create!(name: "Merit - Add to the presentation material including supporting notes", time: 6, unit:"Task 1")
# business_up_5.topics.create!(name: "Pass - Write a report", time: 12, unit:"Task 2")
# business_up_5.topics.create!(name: "Distinction - Add to the report", time: 6, unit:"Task 2")
# business_up_5.topics.create!(name: "Pass- Prepare an information brief", time: 16, unit:"Task 3")
# business_up_5.topics.create!(name: "Merit - Add to the information brief", time: 6, unit:"Task 3")
# business_up_5.topics.create!(name: "Distinction - Add to the information brief", time: 6, unit:"Task 3")
# business_up_5.topics.create!(name: "4.1 The Effectiveness of Communication Types and Channels", time: 12, unit:"Module 4 - Managing Communications")
# business_up_5.topics.create!(name: "4.2 Communication Challenges", time: 8, unit:"Module 4 - Managing Communications")
# business_up_5.topics.create!(name: "4.3 The Factors That Impact on Workplace Communication", time: 8, unit:"Module 4 - Managing Communications")
# business_up_5.topics.create!(name: "4.4 Stakeholder Analysis", time: 4, unit:"Module 4 - Managing Communications")
# business_up_5.topics.create!(name: "4.5 Developing Own Communication Skills Within the Workplace", time: 12, unit:"Module 4 - Managing Communications")
# business_up_5.topics.create!(name: "4.6 Improving Communication Within an Organisation", time: 8, unit:"Module 4 - Managing Communications")
# business_up_5.topics.create!(name: "Pass - Prepare a presentation with supporting speaker notes, using example case studies and/or real-life examples", time: 8, unit:"Task 1")
# business_up_5.topics.create!(name: "Distinction - Extend the presentation and handout materials", time: 6, unit:"Task 1")
# business_up_5.topics.create!(name: "Pass - Prepare an essential information sheet", time: 8, unit:"Task 2")
# business_up_5.topics.create!(name: "Merit - Add to the essential information sheet", time: 6, unit:"Task 2")
# business_up_5.topics.create!(name: "Distinction - Add to the essential information sheet", time: 6, unit:"Task 2")
# business_up_5.topics.create!(name: "Pass- Prepare a portfolio of evidence", time: 4, unit:"Task 3")
# business_up_5.topics.create!(name: "Merit - Add to the portfolio of evidence", time: 6, unit:"Task 3")
# business_up_5.topics.create!(name: "Pass- Prepare a report", time: 8, unit:"Task 4")
# business_up_5.topics.create!(name: "Merit - Add to the report", time: 6, unit:"Task 4")
# business_up_5.topics.create!(name: "5.1 Factors Impacting People", time: 12, unit:"Module 5 - People Management")
# business_up_5.topics.create!(name: "5.2 Managing Individuals and Teams", time: 8, unit:"Module 5 - People Management")
# business_up_5.topics.create!(name: "5.3 Maximising Team and Individual Performance", time: 8, unit:"Module 5 - People Management")
# business_up_5.topics.create!(name: "5.4 People Management Strategies", time: 16, unit:"Module 5 - People Management")
# business_up_5.topics.create!(name: "Pass - Produce a summary report", time: 16, unit:"Task 1")
# business_up_5.topics.create!(name: "Pass - Add a section to the summary report", time: 4, unit:"Task 1")
# business_up_5.topics.create!(name: "Merit - Add a section to the summary report", time: 6, unit:"Task 1")
# business_up_5.topics.create!(name: "Distinction - Add a section to the summary report", time: 6, unit:"Task 1")
# business_up_5.topics.create!(name: "Pass - Submit a draft article for the CIPD website", time: 4, unit:"Task 2")
# business_up_5.topics.create!(name: "Merit - Add to the draft article", time: 6, unit:"Task 2")
# business_up_5.topics.create!(name: "Distinction - Add to the draft article", time: 6, unit:"Task 2")
# business_up_5.topics.create!(name: "Pass- Produce an organisational case study", time: 8, unit:"Task 3")
# business_up_5.topics.create!(name: "6.1 Introduction to Research Projects", time: 8, unit:"Module 6 - Research Proposals")
# business_up_5.topics.create!(name: "6.2 Developing a Research Proposal", time: 12, unit:"Module 6 - Research Proposals")
# business_up_5.topics.create!(name: "6.3 Research Methodology and Ethics", time: 12, unit:"Module 6 - Research Proposals")
# business_up_5.topics.create!(name: "6.4 Research Methodology and Ethics", time: 8, unit:"Module 6 - Research Proposals")
# business_up_5.topics.create!(name: "6.5 Effective Research Project Management", time: 12, unit:"Module 6 - Research Proposals")
# business_up_5.topics.create!(name: "6.6 Producing a Research Proposal", time: 8, unit:"Module 6 - Research Proposals")
# business_up_5.topics.create!(name: "6.7 Evaluating the Research Project", time: 8, unit:"Module 6 - Research Proposals")
# business_up_5.topics.create!(name: "6.8 Evaluating Research Project Outcomes", time: 12, unit:"Module 6 - Research Proposals")
# business_up_5.topics.create!(name: "6.9 Presenting Research Project Outcomes", time: 8, unit:"Module 6 - Research Proposals")
# business_up_5.topics.create!(name: "Pass - Produce a research proposal", time: 12, unit:"Task 1")
# business_up_5.topics.create!(name: "Merit - Add to the research proposal", time: 6, unit:"Task 1")
# business_up_5.topics.create!(name: "Distinction - Add to the research proposal", time: 6, unit:"Task 1")
# business_up_5.topics.create!(name: "Pass - Undertake your research and monitor its progress.", time: 8, unit:"Task 2")
# business_up_5.topics.create!(name: "Pass- Produce a final project report.", time: 12, unit:"Task 3")
# business_up_5.topics.create!(name: "Merit - Add to the final report", time: 6, unit:"Task 3")
# business_up_5.topics.create!(name: "Distinction - Add to the final report", time: 6, unit:"Task 3")
# business_up_5.topics.create!(name: "7.1 Introduction to Marketing in Business", time: 8, unit:"Module 7 - Marketing Principles and Practices")
# business_up_5.topics.create!(name: "7.2 External Factors Influencing Marketing", time: 12, unit:"Module 7 - Marketing Principles and Practices")
# business_up_5.topics.create!(name: "7.3 Marketing in Not-for-Profit Organizations", time: 12, unit:"Module 7 - Marketing Principles and Practices")
# business_up_5.topics.create!(name: "7.4 Marketing Strategy and Sales Support", time: 8, unit:"Module 7 - Marketing Principles and Practices")
# business_up_5.topics.create!(name: "7.5 Principles of Marketing", time: 8, unit:"Module 7 - Marketing Principles and Practices")
# business_up_5.topics.create!(name: "7.6 Digital Marketing Fundamentals", time: 12, unit:"Module 7 - Marketing Principles and Practices")
# business_up_5.topics.create!(name: "7.7 Marketing Research Methods", time: 8, unit:"Module 7 - Marketing Principles and Practices")
# business_up_5.topics.create!(name: "7.8 Digital Marketing Channels", time: 8, unit:"Module 7 - Marketing Principles and Practices")
# business_up_5.topics.create!(name: "7.9 Challenges in Marketing", time: 12, unit:"Module 7 - Marketing Principles and Practices")
# business_up_5.topics.create!(name: "7.10 Developing a Marketing Plan", time: 12, unit:"Module 7 - Marketing Principles and Practices")
# business_up_5.topics.create!(name: "Pass - Produce a file", time: 12, unit:"Task 1")
# business_up_5.topics.create!(name: "Merit - Add to the file", time: 6, unit:"Task 1")
# business_up_5.topics.create!(name: "Pass - Prepare a presentation and an accompanying handout", time: 8, unit:"Task 2")
# business_up_5.topics.create!(name: "Merit - Add to the presentation and accompanying handout", time: 6, unit:"Task 2")
# business_up_5.topics.create!(name: "Distinction - Add to the presentation and accompanying handout", time: 6, unit:"Task 2")
# business_up_5.topics.create!(name: "Pass- Produce a training pack", time: 8, unit:"Task 3")
# business_up_5.topics.create!(name: "Distinction - Add to the training pack", time: 6, unit:"Task 3")
# business_up_5.topics.create!(name: "Pass - Develop a marketing plan", time: 12, unit:"Task 4")
# business_up_5.topics.create!(name: "8.1 Introduction to Sustainability in Organizations", time: 8, unit:"Module 8 - Managing Sustainabililty")
# business_up_5.topics.create!(name: "8.2 Sustainability Issues and Impact", time: 12, unit:"Module 8 - Managing Sustainabililty")
# business_up_5.topics.create!(name: "8.3 Legislation, Regulation, and Guidance", time: 12, unit:"Module 8 - Managing Sustainabililty")
# business_up_5.topics.create!(name: "8.4 Ethical Operations and Impact", time: 8, unit:"Module 8 - Managing Sustainabililty")
# business_up_5.topics.create!(name: "8.5 Sustainability Audit", time: 12, unit:"Module 8 - Managing Sustainabililty")
# business_up_5.topics.create!(name: "8.6 Quality Standards and Organizational Sustainability", time: 12, unit:"Module 8 - Managing Sustainabililty")
# business_up_5.topics.create!(name: "8.7 Implementing and Managing Sustainability", time: 8, unit:"Module 8 - Managing Sustainabililty")
# business_up_5.topics.create!(name: "Pass - Prepare a presentation and produce a supplementary information brief", time: 16, unit:"Task 1")
# business_up_5.topics.create!(name: "Merit - Add to the presentation and supplementary information brief", time: 6, unit:"Task 1")
# business_up_5.topics.create!(name: "Distinction - Add to the presentation and supplementary information brief", time: 6, unit:"Task 1")
# business_up_5.topics.create!(name: "Pass - Undertake a sustainability audit", time: 12, unit:"Task 2")
# business_up_5.topics.create!(name: "Pass- Produce a briefing document", time: 8, unit:"Task 3")
# business_up_5.topics.create!(name: "Merit - Add to the briefing document", time: 6, unit:"Task 3")
# business_up_5.topics.create!(name: "Distinction - Add to the briefing document", time: 6, unit:"Task 3")

# idtcs_3 = Subject.create!(
#   name: "IDTCS(UP) - Level 3",
#   category: :up,
#   )

# idtcs_3.topics.create!(name: "Unit 1: Using Computer Programming Languages", time: 8, unit:"Module 1 - Introduction to Computer Programming")
# idtcs_3.topics.create!(name: "Unit 2: Understand the basics of Computer Programming", time: 12, unit:"Module 1 - Introduction to Computer Programming")
# idtcs_3.topics.create!(name: "Unit 3: Understand a range of Programming Languages", time: 4, unit:"Module 1 - Introduction to Computer Programming")
# idtcs_3.topics.create!(name: "Unit 4: Object-Oriented Programming (OOP)", time: 4, unit:"Module 1 - Introduction to Computer Programming")
# idtcs_3.topics.create!(name: "Unit 5: Writing a Basic Computer Programme", time: 8, unit:"Module 1 - Introduction to Computer Programming")
# idtcs_3.topics.create!(name: "Task 1 (Produce an information document)", time: 12, unit:"Assignment - Introduction to Computer Programming")
# idtcs_3.topics.create!(name: "Task 2 (Write a computer programme)", time: 20, unit:"Assignment - Introduction to Computer Programming")
# idtcs_3.topics.create!(name: "Task 3 (Test the programme)", time: 12, unit:"Assignment - Introduction to Computer Programming")
# idtcs_3.topics.create!(name: "Task 4M (Record a demonstration of the programme)", time: 12, unit:"Assignment - Introduction to Computer Programming")
# idtcs_3.topics.create!(name: "Unit 1: Introduction to Computing Mathematics", time: 4, unit:"Module 2: Introduction to Computing Mathematics")
# idtcs_3.topics.create!(name: "Unit 2: Understand Problem Solving Techniques using Computing Mathematics", time: 4, unit:"Module 2: Introduction to Computing Mathematics")
# idtcs_3.topics.create!(name: "Unit 3: Basic Mathematical Formulas for Computing Mathematics", time: 4, unit:"Module 2: Introduction to Computing Mathematics")
# idtcs_3.topics.create!(name: "Unit 4: Mathematical Logic", time: 8, unit:"Module 2: Introduction to Computing Mathematics")
# idtcs_3.topics.create!(name: "Unit 5: Understand Probability in Mathematics", time: 8, unit:"Module 2: Introduction to Computing Mathematics")
# idtcs_3.topics.create!(name: "Unit 6: Understand Binary Mathematics", time: 8, unit:"Module 2: Introduction to Computing Mathematics")
# idtcs_3.topics.create!(name: "Task 1 (Create a Presentation)", time: 12, unit:"Assignment - Introduction to Computing Mathematics")
# idtcs_3.topics.create!(name: "Task 2 (Mathematical Calculations)", time: 4, unit:"Assignment - Introduction to Computing Mathematics")
# idtcs_3.topics.create!(name: "Task 3 (Logic and Probability Calculations)", time: 8, unit:"Assignment - Introduction to Computing Mathematics")
# idtcs_3.topics.create!(name: "Unit 1: Understanding the Use of Cybersecurity", time: 8, unit:"Module 3: Introduction to Cybersecurity")
# idtcs_3.topics.create!(name: "Unit 2: How to keep yourself and others safe when working online", time: 8, unit:"Module 3: Introduction to Cybersecurity")
# idtcs_3.topics.create!(name: "Unit 3: Security Measures", time: 8, unit:"Module 3: Introduction to Cybersecurity")
# idtcs_3.topics.create!(name: "Unit 4: Managing Cybersecurity Risks", time: 8, unit:"Module 3: Introduction to Cybersecurity")
# idtcs_3.topics.create!(name: "Unit 5: Implementing security measures on a range of devices", time: 8, unit:"Module 3: Introduction to Cybersecurity")
# idtcs_3.topics.create!(name: "Task 1 (Create an Induction Presentation)", time: 8, unit:"Assignment - Introduction to Cyber Security")
# idtcs_3.topics.create!(name: "Task 2 (Create a ‘Keep safe when working online’ guide)", time: 8, unit:"Assignment - Introduction to Cyber Security")
# idtcs_3.topics.create!(name: "Task 3 (Draft a response to queries )", time: 8, unit:"Assignment - Introduction to Cyber Security")
# idtcs_3.topics.create!(name: "Task 4 (Create a disaster recovery plan )", time: 12, unit:"Assignment - Introduction to Cyber Security")
# idtcs_3.topics.create!(name: "Task 5 (Implement a range of security measures)", time: 12, unit:"Assignment - Introduction to Cyber Security")
# idtcs_3.topics.create!(name: "Unit 1: The Evolution of Computing and Technology", time: 8, unit:"Module 4: Introduction to Digital Technologies")
# idtcs_3.topics.create!(name: "Unit 2: Components of a Digital Environment", time: 8, unit:"Module 4: Introduction to Digital Technologies")
# idtcs_3.topics.create!(name: "Unit 3: Cloud-based (Internet) Technologies", time: 8, unit:"Module 4: Introduction to Digital Technologies")
# idtcs_3.topics.create!(name: "Unit 4: The Importance of Technology in Society", time: 8, unit:"Module 4: Introduction to Digital Technologies")
# idtcs_3.topics.create!(name: "Task 1 (Planning the strategy-presentation)", time: 4, unit:"Assignment - Introduction to Digital Technologies")
# idtcs_3.topics.create!(name: "Task 2 (The digital environment components - proposal)", time: 8, unit:"Assignment - Introduction to Digital Technologies")
# idtcs_3.topics.create!(name: "Task 3 (Using cloud technologies - report)", time: 8, unit:"Assignment - Introduction to Digital Technologies")
# idtcs_3.topics.create!(name: "Task 4 (Technology within industry sectors - information guide)", time: 8, unit:"Assignment - Introduction to Digital Technologies")
# idtcs_3.topics.create!(name: "Task 5 (Planning for implementation - project plan)", time: 8, unit:"Assignment - Introduction to Digital Technologies")
# idtcs_3.topics.create!(name: "Unit 1: Current and Future Emerging Technologies in the Digital World", time: 8, unit:"Module 5: Introduction to Emerging Technologies")
# idtcs_3.topics.create!(name: "Unit 2: Artificial Intelligence in Society", time: 8, unit:"Module 5: Introduction to Emerging Technologies")
# idtcs_3.topics.create!(name: "Unit 3: Managing Change", time: 8, unit:"Module 5: Introduction to Emerging Technologies")
# idtcs_3.topics.create!(name: "Unit 4: Presenting Information on Emerging Technologies", time: 4, unit:"Module 5: Introduction to Emerging Technologies")
# idtcs_3.topics.create!(name: "Unit 5: The Future of Computing", time: 4, unit:"Module 5: Introduction to Emerging Technologies")
# idtcs_3.topics.create!(name: "Task 1 (Carry out research for your presentation)", time: 12, unit:"Assignment - Introduction to Emerging Technologies")
# idtcs_3.topics.create!(name: "Task 2 (Produce and deliver your Presentation)", time: 8, unit:"Assignment - Introduction to Emerging Technologies")
# idtcs_3.topics.create!(name: "Task 3 (Implications of change - report)", time: 8, unit:"Assignment - Introduction to Emerging Technologies")
# idtcs_3.topics.create!(name: "Unit 1: Understanding the Purpose of Mobile Applications", time: 8, unit:"Module 6: Introduction to Mobile Application Development")
# idtcs_3.topics.create!(name: "Unit 2: Planning for Mobile Application Development", time: 8, unit:"Module 6: Introduction to Mobile Application Development")
# idtcs_3.topics.create!(name: "Unit 3: Devloping a Mobile App", time: 8, unit:"Module 6: Introduction to Mobile Application Development")
# idtcs_3.topics.create!(name: "Unit 4: Testing a Mobile App", time: 8, unit:"Module 6: Introduction to Mobile Application Development")
# idtcs_3.topics.create!(name: "Unit 5: Launching a Mobile App to the Marketplace", time: 8, unit:"Module 6: Introduction to Mobile Application Development")
# idtcs_3.topics.create!(name: "Task 1 (The purpose of the application -presentation)", time: 8, unit:"Assignment - Introduction to Mobile Application Development")
# idtcs_3.topics.create!(name: "Task 2 (Planning the mobile application - technical requirements document)", time: 12, unit:"Assignment - Introduction to Mobile Application Development")
# idtcs_3.topics.create!(name: "Task 3 (Develop a mobile application)", time: 20, unit:"Assignment - Introduction to Mobile Application Development")
# idtcs_3.topics.create!(name: "Task 4 (Testing the application)", time: 12, unit:"Assignment - Introduction to Mobile Application Development")
# idtcs_3.topics.create!(name: "Task 5 (Launching the application)", time: 12, unit:"Assignment - Introduction to Mobile Application Development")
# idtcs_3.topics.create!(name: "Unit 1: Website Development Planning", time: 8, unit:"Module 7: Intro to Web Development")
# idtcs_3.topics.create!(name: "Unit 2: Producing Interactive Webpages", time: 8, unit:"Module 7: Intro to Web Development")
# idtcs_3.topics.create!(name: "Unit 3: Testing Webpages", time: 8, unit:"Module 7: Introto Web Development")
# idtcs_3.topics.create!(name: "Unit 4: Publishing Websites Online", time: 8, unit:"Module 7: Intro to Web Development")
# idtcs_3.topics.create!(name: "Task 1 (Website planning)", time: 12, unit:"Assignment - Introduction to Web Development")
# idtcs_3.topics.create!(name: "Task 2 (Design and implementation of the website)", time: 20, unit:"Assignment - Introduction to Web Development")
# idtcs_3.topics.create!(name: "Task 3 (Testing the website)", time: 12, unit:"Assignment - Introduction to Web Development")
# idtcs_3.topics.create!(name: "Task 4 (Publishing the website)", time: 12, unit:"Assignment - Introduction to Web Development")

# idtcs_4 = Subject.create!(
#   name: "IDTCS(UP) - Level 4",
#   category: :up,
#   )

# idtcs_4.topics.create!(name: "Unit 1: Understand how IT has changed the way people live and work", time: 16, unit:"Module 1 - IT & Society")
# idtcs_4.topics.create!(name: "Unit 2: Understand IT issues in society", time: 12, unit:"Module 1 - IT & Society")
# idtcs_4.topics.create!(name: "Unit 3: Understand current legal, ethical and regulatory issues in IT", time: 16, unit:"Module 1 - IT & Society")
# idtcs_4.topics.create!(name: "Activity 1", time: 20, unit:"Assignment - IT & Society")
# idtcs_4.topics.create!(name: "Activity 2", time: 28, unit:"Assignment - IT & Society")
# idtcs_4.topics.create!(name: "Activity 3", time: 20, unit:"Assignment - IT & Society")
# idtcs_4.topics.create!(name: "Unit 1: Understand principles of e-commerce", time: 12, unit:"Module 2: E-Commerce Applications")
# idtcs_4.topics.create!(name: "Unit 2: Understand why small businesses use e-commerce", time: 16, unit:"Module 2: E-Commerce Applications")
# idtcs_4.topics.create!(name: "Unit 3: Understand e-commerce models used in small businesses", time: 12, unit:"Module 2: E-Commerce Applications")
# idtcs_4.topics.create!(name: "Unit 4: Understand e-commerce applications", time: 8, unit:"Module 2: E-Commerce Applications")
# idtcs_4.topics.create!(name: "Unit 5: Be able create an e-commerce site", time: 12, unit:"Module 2: E-Commerce Applications")
# idtcs_4.topics.create!(name: "Activity 1", time: 20, unit:"Assignment - E-Commerce Applications")
# idtcs_4.topics.create!(name: "Activity 2", time: 16, unit:"Assignment - E-Commerce Applications")
# idtcs_4.topics.create!(name: "Activity 3", time: 28, unit:"Assignment - E-Commerce Applications")
# idtcs_4.topics.create!(name: "Activity 4", time: 20, unit:"Assignment - E-Commerce Applications")
# idtcs_4.topics.create!(name: "Activity 5", time: 20, unit:"Assignment - E-Commerce Applications")
# idtcs_4.topics.create!(name: "Unit 1: Understand principles of human computer", time: 16, unit:"Module 3: Human Computer Interaction")
# idtcs_4.topics.create!(name: "Unit 2: Be able to plan an interface for a", time: 16, unit:"Module 3: Human Computer Interaction")
# idtcs_4.topics.create!(name: "Unit 3: Be able to create a prototype using HCI principles", time: 16, unit:"Module 3: Human Computer Interaction")
# idtcs_4.topics.create!(name: "Activity 1", time: 12, unit:"Assignment - Human Computer Interaction")
# idtcs_4.topics.create!(name: "Activity 2", time: 16, unit:"Assignment - Human Computer Interaction")
# idtcs_4.topics.create!(name: "Activity 3", time: 20, unit:"Assignment - Human Computer Interaction")
# idtcs_4.topics.create!(name: "Unit 1: Understand components of computer", time: 16, unit:"Module 4: Computer Systems & Software")
# idtcs_4.topics.create!(name: "Unit 2: Understand computer software", time: 20, unit:"Module 4: Computer Systems & Software")
# idtcs_4.topics.create!(name: "Activity 1", time: 16, unit:"Assignment - Computer Systems & Software")
# idtcs_4.topics.create!(name: "Activity 2", time: 20, unit:"Assignment - Computer Systems & Software")
# idtcs_4.topics.create!(name: "Unit 1: Understand principles of computer", time: 16, unit:"Module 5: Computer Programming")
# idtcs_4.topics.create!(name: "Unit 2: Be able to develop a computer", time: 8, unit:"Module 5: Computer Programming")
# idtcs_4.topics.create!(name: "Unit 3: Be able to evaluate a computer", time: 16, unit:"Module 5: Computer Programming")
# idtcs_4.topics.create!(name: "Activity 1", time: 16, unit:"Assignment - Computer Programming")
# idtcs_4.topics.create!(name: "Activity 2", time: 20, unit:"Assignment - Computer Programming")
# idtcs_4.topics.create!(name: "Activity 3", time: 28, unit:"Assignment - Computer Programming")
# idtcs_4.topics.create!(name: "Activity 4", time: 16, unit:"Assignment - Computer Programming")
# idtcs_4.topics.create!(name: "Unit 1: Understand database management systems", time: 20, unit:"Module 6: Relational Database Systems")
# idtcs_4.topics.create!(name: "Unit 2: Understand database design", time: 16, unit:"Module 6: Relational Database Systems")
# idtcs_4.topics.create!(name: "Unit 3: Be able to design a database system", time: 16, unit:"Module 6: Relational Database Systems")
# idtcs_4.topics.create!(name: "Activity 1", time: 28, unit:"Assignment - Relational Database Systems")
# idtcs_4.topics.create!(name: "Activity 2", time: 16, unit:"Assignment - Relational Database Systems")
# idtcs_4.topics.create!(name: "Activity 3", time: 28, unit:"Assignment - Relational Database Systems")
# idtcs_4.topics.create!(name: "Unit 1: Understand  the  software  engineering", time: 12, unit:"Module 7: Software Engineering")
# idtcs_4.topics.create!(name: "Unit 2: Understand key aspects of software", time: 16, unit:"Module 7: Software Engineering")
# idtcs_4.topics.create!(name: "Unit 3: Be able to apply a software engineering", time: 16, unit:"Module 7: Software Engineering")
# idtcs_4.topics.create!(name: "Activity 1", time: 28, unit:"Assignment - Software Engineering")
# idtcs_4.topics.create!(name: "Activity 2", time: 16, unit:"Assignment - Software Engineering")
# idtcs_4.topics.create!(name: "Activity 3", time: 20, unit:"Assignment - Software Engineering")
# idtcs_4.topics.create!(name: "Unit 1: Understand systems analysis and design ", time: 12, unit:"Module 8: Systems Analysis & Design")
# idtcs_4.topics.create!(name: "Unit 2: Be able to use systems analysis and design techniques to recommend improvements to an existing system", time: 16, unit:"Module 8: Systems Analysis & Design")
# idtcs_4.topics.create!(name: "Unit 3: Be able to develop a solution to improve an existing system", time: 12, unit:"Module 8: Systems Analysis & Design")
# idtcs_4.topics.create!(name: "Activity 1", time: 20, unit:"Assignment - Systems Analysis & Design")
# idtcs_4.topics.create!(name: "Activity 2", time: 20, unit:"Assignment - Systems Analysis & Design")
# idtcs_4.topics.create!(name: "Activity 3", time: 16, unit:"Assignment - Systems Analysis & Design")
# idtcs_4.topics.create!(name: "Unit 1: Understand information systems used in organisations", time: 12, unit:"Module 9: Information Systems Theory & Practice")
# idtcs_4.topics.create!(name: "Unit 2: Be able to plan the development of an information system", time: 16, unit:"Module 9: Information Systems Theory & Practice")
# idtcs_4.topics.create!(name: "Unit 3: Understand how to review the performance of an information system", time: 16, unit:"Module 9: Information Systems Theory & Practice")
# idtcs_4.topics.create!(name: "Activity 1", time: 16, unit:"Assignment - Information Systems Theory & Practice")
# idtcs_4.topics.create!(name: "Activity 2", time: 20, unit:"Assignment - Information Systems Theory & Practice")
# idtcs_4.topics.create!(name: "Activity 3", time: 16, unit:"Assignment - Information Systems Theory & Practice")
# idtcs_4.topics.create!(name: "Unit 1: Understand management information systems in organisations", time: 20, unit:"Module 10: Management Information Systems")
# idtcs_4.topics.create!(name: "Unit 2: Be able to evaluate a management information system in an organisation", time: 12, unit:"Module 10: Management Information Systems")
# idtcs_4.topics.create!(name: "Unit 3: Be able to plan improvements to a management information system", time: 12, unit:"Module 10: Management Information Systems")
# idtcs_4.topics.create!(name: "Activity 1", time: 20, unit:"Assignment - Management Information Systems")
# idtcs_4.topics.create!(name: "Activity 2", time: 28, unit:"Assignment - Management Information Systems")

# maths_as1 = Subject.create!(
#   name: "Mathematics AS Level 1",
#   category: :as,
#   )

# maths_as1.topics.create!(name: "Introduction to the Course", time: 1, unit:"Introduction to the Course")
# maths_as1.topics.create!(name: "Pre-course", time: 1, unit:"Pre-course")
# maths_as1.topics.create!(name: "Unit 1: Proof", time: 4, unit:"Topic 1.1 - Introduction to Methods of proof")
# maths_as1.topics.create!(name: "Unit 2: Algebra and Functions", time: 5, unit:"Topic 2.1 - Algebraic Expressions, Indices and Surds")
# maths_as1.topics.create!(name: "Unit 2: Algebra and Functions", time: 4, unit:"Topic 2.2 - Quadratics")
# maths_as1.topics.create!(name: "Unit 2: Algebra and Functions", time: 4, unit:"Topic 2.3 -  Simultaneous Equations")
# maths_as1.topics.create!(name: "Unit 2: Algebra and Functions", time: 6, unit:"Topic 2.4 - Inequalities")
# maths_as1.topics.create!(name: "Unit 2: Algebra and Functions", time: 5, unit:"Topic 2.5 - Polynomial and Reciprocal Functions")
# maths_as1.topics.create!(name: "Unit 2: Algebra and Functions", time: 6, unit:"Topic 2.6 - Transformations and Symmetries")
# maths_as1.topics.create!(name: "Unit 2: Algebra and Functions", time: 4, unit:"Topic 2.7 - Algebraic Division")
# maths_as1.topics.create!(name: "Unit 2: Algebra and Functions", time: 3, unit:"End of Unit Assessments", milestone: true, has_grade: true)
# maths_as1.topics.create!(name: "Unit 3: Coordinate Geometry", time: 6, unit:"Topic 3.1 - Coordinate Geometry of Straigh Lines")
# maths_as1.topics.create!(name: "Unit 3: Coordinate Geometry", time: 8, unit:"Topic 3.2 - Coordinate Geometry of Circles")
# maths_as1.topics.create!(name: "Unit 4: Sequences, Series and Binomial Expansion", time: 2, unit:"Topic 4.1 - Arithmetic Sequences and Series")
# maths_as1.topics.create!(name: "Unit 4: Sequences, Series and Binomial Expansion", time: 3, unit:"Topic 4.2 - Geometric Sequences and Series")
# maths_as1.topics.create!(name: "Unit 4: Sequences, Series and Binomial Expansion", time: 5, unit:"Topic 4.3 - General Sequences, Series and Notation")
# maths_as1.topics.create!(name: "Unit 4: Sequences, Series and Binomial Expansion", time: 7, unit:"Topic 4.4 - Binomial Expansion for Positive Integer Exponents")
# maths_as1.topics.create!(name: "Unit 4: Sequences, Series and Binomial Expansion", time: 3, unit:"End of Unit Assessments", milestone: true, has_grade: true)
# maths_as1.topics.create!(name: "Unit 5: Trigonometry and Trigonometric Functions", time: 6, unit:"Topic 5.1 - Trigonometry in Triangles")
# maths_as1.topics.create!(name: "Unit 5: Trigonometry and Trigonometric Functions", time: 5, unit:"Topic 5.2 - Trigonometry in Circles")
# maths_as1.topics.create!(name: "Unit 5: Trigonometry and Trigonometric Functions", time: 2, unit:"Topic 5.3 - Trigonometric Functions")
# maths_as1.topics.create!(name: "Unit 5: Trigonometry and Trigonometric Functions", time: 5, unit:"Topic 5.4 - Trigonometric Identities")
# maths_as1.topics.create!(name: "Unit 5: Trigonometry and Trigonometric Functions", time: 5, unit:"Topic 5.5 - Trigonometric Equations")
# maths_as1.topics.create!(name: "Unit 5: Trigonometry and Trigonometric Functions", time: 1, unit:"End of Unit Assessments", milestone: true, has_grade: true)
# maths_as1.topics.create!(name: "Unit 6: Exponentials and Logarithms", time: 2, unit:"Topic 6.1 - Exponential and Logarithmic Functions")
# maths_as1.topics.create!(name: "Unit 6: Exponentials and Logarithms", time: 6, unit:"Topic 6.2 - Manipulating Exponential and Logarithmic Expressions")
# maths_as1.topics.create!(name: "Unit 6: Exponentials and Logarithms", time: 3, unit:"End of Unit Assessments", milestone: true, has_grade: true)
# maths_as1.topics.create!(name: "Unit 7: Differentiation", time: 11, unit:"Topic 7.1 - Introduction to Differentiation: Powers")
# maths_as1.topics.create!(name: "Unit 7: Differentiation", time: 4, unit:"Topic 7.2 - Stationary Points and Function Behaviour")
# maths_as1.topics.create!(name: "Unit 7: Differentiation", time: 1, unit:"End of Unit Assessments", milestone: true, has_grade: true)
# maths_as1.topics.create!(name: "Unit 8: Integration", time: 6, unit:"Topic 8.1 - Indefinite Integration")
# maths_as1.topics.create!(name: "Unit 8: Integration", time: 5, unit:"Topic 8.2 - Definite Integration and Area under a Curve")
# maths_as1.topics.create!(name: "Unit 8: Integration", time: 2, unit:"Topic 8.3 - Numerical Integration using the Trapezium Rule")
# maths_as1.topics.create!(name: "Unit 8: Integration", time: 3, unit:"End of Unit Assessments", milestone: true, has_grade: true)
# maths_as1.topics.create!(name: "Warm up mock", time: 2, unit:"Warm up mock")
# maths_as1.topics.create!(name: "Pure Mathematics - Paper 1 MOCK (AS Component)", time: 1.5, unit:"Pure Mathematics - Paper 1 MOCK (AS Component)")
# maths_as1.topics.create!(name: "Pure Mathematics - Paper 2 MOCK (AS Component)", time: 2, unit:"Pure Mathematics - Paper 2 MOCK (AS Component)")
# maths_as1.topics.create!(name: "Unit 11: Representing and Summarising Data", time: 5, unit:"Topic 11.1 - Measures of Location and Variation")
# maths_as1.topics.create!(name: "Unit 11: Representing and Summarising Data", time: 8, unit:"Topic 11.2 - Representing and Comparing Data using Diagrams")
# maths_as1.topics.create!(name: "Unit 11: Representing and Summarising Data", time: 1, unit:"End of Unit Assessments", milestone: true, has_grade: true)
# maths_as1.topics.create!(name: "Unit 12: Probability", time: 7, unit:"Topic 12.1 - Events, Set Notation and Probability Calculations")
# maths_as1.topics.create!(name: "Unit 12: Probability", time: 3, unit:"Topic 12.2 - Conditional Probability")
# maths_as1.topics.create!(name: "Unit 12: Probability", time: 1, unit:"End of Unit Assessments", milestone: true, has_grade: true)
# maths_as1.topics.create!(name: "Unit 13: Correlation and Regression", time: 9, unit:"Topic 13.1 - Scatter Diagrams and Least Squares Linear Regression")
# maths_as1.topics.create!(name: "Unit 13: Correlation and Regression", time: 7, unit:"Topic 13.2 - Product Moment Correlation Coeficient (PMCC)")
# maths_as1.topics.create!(name: "Unit 13: Correlation and Regression", time: 1, unit:"End of Unit Assessments", milestone: true, has_grade: true)
# maths_as1.topics.create!(name: "Unit 14: Random Variables and Distributions", time: 13, unit:"Topic 14.1. Discrete Random Variables and Distributions")
# maths_as1.topics.create!(name: "Unit 14: Random Variables and Distributions", time: 8, unit:"Topic 14.2. Continuous Random Variables and Normal Distribution")
# maths_as1.topics.create!(name: "Unit 14: Random Variables and Distributions", time: 1, unit:"End of Unit Assessments", milestone: true, has_grade: true)
# maths_as1.topics.create!(name: "Warm up mock", time: 2, unit:"Warm up mock")
# maths_as1.topics.create!(name: "Statistics - Paper 1 MOCK (AS Component)", time: 2, unit:"Statistics - Paper 1 MOCK (AS Component)")

# maths_as2 = Subject.create!(
#   name: "Mathematics AS Level 2",
#   category: :as,
#   )

# maths_as2.topics.create!(name: "Unit 1: Proof", time: 3, unit:"Topic 1.2 - Proof by Contradiction")
# maths_as2.topics.create!(name: "Unit 2: Algebra and Functions", time: 2, unit:"Topic 2.8 - Algebraic Fraction Manipulation")
# maths_as2.topics.create!(name: "Unit 2: Algebra and Functions", time: 4, unit:"Topic 2.9 - Partial Fractions")
# maths_as2.topics.create!(name: "Unit 2: Algebra and Functions", time: 4, unit:"Topic 2.10 - Composite and Inverse Functions")
# maths_as2.topics.create!(name: "Unit 2: Algebra and Functions", time: 5, unit:"Topic 2.11 - Modulus Function")
# maths_as2.topics.create!(name: "Unit 2: Algebra and Functions", time: 3, unit:"Topic 2.12 - Composite Transformations")
# maths_as2.topics.create!(name: "Unit 2: Algebra and Functions", time: 3, unit:"End of Unit Assessments", milestone: true, has_grade: true)
# maths_as2.topics.create!(name: "Unit 3: Coordinate Geometry", time: 3, unit:"Topic 3.3 - Parametric Equations")
# maths_as2.topics.create!(name: "Unit 3: Coordinate Geometry", time: 1, unit:"End of Unit Assessments", milestone: true, has_grade: true)
# maths_as2.topics.create!(name: "Unit 4: Sequences, Series and Binomial Expansion", time: 7, unit:"Topic 4.5 - Binomial Expansion for Rational Powers")
# maths_as2.topics.create!(name: "Unit 4: Sequences, Series and Binomial Expansion", time: 3, unit:"End of Unit Assessments", milestone: true, has_grade: true)
# maths_as2.topics.create!(name: "Unit 5: Trigonometry and Trigonometric Functions", time: 2, unit:"Topic 5.6 - Reciprocal Trigonometric Functions and Identities ")
# maths_as2.topics.create!(name: "Unit 5: Trigonometry and Trigonometric Functions", time: 3, unit:"Topic 5.7 - Inverse Trigonometric Functions")
# maths_as2.topics.create!(name: "Unit 5: Trigonometry and Trigonometric Functions", time: 6, unit:"Topic 5.8 - Compound, Double and Half-Angle Formulae")
# maths_as2.topics.create!(name: "Unit 5: Trigonometry and Trigonometric Functions", time: 3, unit:"Topic 5.9 - Harmonic Forms")
# maths_as2.topics.create!(name: "Unit 5: Trigonometry and Trigonometric Functions", time: 2, unit:"End of Unit Assessments", milestone: true, has_grade: true)
# maths_as2.topics.create!(name: "Unit 6: Exponentials and Logarithms", time: 2, unit:"Topic 6.3 - Natural Exponential and Logarithmic Functions")
# maths_as2.topics.create!(name: "Unit 6: Exponentials and Logarithms", time: 8, unit:"Topic 6.4 - Modelling with Exponential and Logarithmic Functions")
# maths_as2.topics.create!(name: "Unit 6: Exponentials and Logarithms", time: 3, unit:"End of Unit Assessments", milestone: true, has_grade: true)
# maths_as2.topics.create!(name: "Unit 7: Differentiation", time: 5, unit:"Topic 7.3 - Differentiating Exponentials, Logarithms and Trigonometric Functions")
# maths_as2.topics.create!(name: "Unit 7: Differentiation", time: 7, unit:"Topic 7.4 - Differentiation Techniques: Product Rule, Quotient Rule and Chain Rule")
# maths_as2.topics.create!(name: "Unit 7: Differentiation", time: 5, unit:"Topic 7.5 - Differentiating Implicit and Parametric Functions")
# maths_as2.topics.create!(name: "Unit 7: Differentiation", time: 3, unit:"Topic 7.6 - Connected Rates of Change")
# maths_as2.topics.create!(name: "Unit 7: Differentiation", time: 1, unit:"End of Unit Assessments", milestone: true, has_grade: true)
# maths_as2.topics.create!(name: "Unit 8: Integration", time: 4, unit:"Topic 8.4 - Integrating Standard Functions")
# maths_as2.topics.create!(name: "Unit 8: Integration", time: 5, unit:"Topic 8.5 - Integration by Recognition of Known Derivatives and using Trigonometric Identities")
# maths_as2.topics.create!(name: "Unit 8: Integration", time: 5, unit:"Topic 8.6 - Volumes of Revolution")
# maths_as2.topics.create!(name: "Unit 8: Integration", time: 7, unit:"Topic 8.7 - Integration Techniques: Integration by Substitution and Integration by Parts")
# maths_as2.topics.create!(name: "Unit 8: Integration", time: 3, unit:"Topic 8.8 - Integration of Rational Functions using Partial Fractions")
# maths_as2.topics.create!(name: "Unit 8: Integration", time: 2, unit:"Topic 8.9 - Differential Equations")
# maths_as2.topics.create!(name: "Unit 8: Integration", time: 2, unit:"Topic 8.10 - Modelling with Differential Equations")
# maths_as2.topics.create!(name: "Unit 8: Integration", time: 3, unit:"End of Unit Assessments", milestone: true, has_grade: true)
# maths_as2.topics.create!(name: "Unit 9: Numerical Methods", time: 1, unit:"Topic 9.1 - Locating Roots")
# maths_as2.topics.create!(name: "Unit 9: Numerical Methods", time: 4, unit:"Topic 9.2 - Iterative Methods for Solving Equations")
# maths_as2.topics.create!(name: "Unit 9: Numerical Methods", time: 1, unit:"End of Unit Assessments", milestone: true, has_grade: true)
# maths_as2.topics.create!(name: "Unit 10: Vectors", time: 5, unit:"Topic 10.1 - Vector Representations and Operations")
# maths_as2.topics.create!(name: "Unit 10: Vectors", time: 3, unit:"Topic 10.2 - Position Vectors and Geometrical Problems")
# maths_as2.topics.create!(name: "Unit 10: Vectors", time: 5, unit:"Topic 10.3 - Vector Equation of the Line")
# maths_as2.topics.create!(name: "Unit 10: Vectors", time: 5, unit:"Topic 10.4 - Scalar Product")
# maths_as2.topics.create!(name: "Unit 10: Vectors", time: 3, unit:"End of Unit Assessments", milestone: true, has_grade: true)
# maths_as2.topics.create!(name: "Warm up mock", time: 2, unit:"Warm up mock")
# maths_as2.topics.create!(name: "Pure Mathematics - Paper 3 MOCK (AS Component)", time: 1.5 , unit:"Pure Mathematics - Paper 3 MOCK (AS Component)")
# maths_as2.topics.create!(name: "Pure Mathematics - Paper 4 MOCK (AS Component)", time: 2, unit:"Pure Mathematics - Paper 4 MOCK (AS Component)")
# maths_as2.topics.create!(name: "Unit 16: Mathematical Models in Mechanics", time: 2, unit:"Topic 16.1 - Quantities and Units in Mechanics Models")
# maths_as2.topics.create!(name: "Unit 16: Mathematical Models in Mechanics", time: 13, unit:"Topic 16.2 - Representing Physical Quantities in Mechanics Models")
# maths_as2.topics.create!(name: "Unit 16: Mathematical Models in Mechanics", time: 1, unit:"MA: End of Unit Assessment 16")
# maths_as2.topics.create!(name: "Unit 17: Kinematics of Particles Moving in a Straight Line", time: 4, unit:"Topic 17.1 - Constant Acceleration Formulae")
# maths_as2.topics.create!(name: "Unit 17: Kinematics of Particles Moving in a Straight Line", time: 6, unit:"Topic 17.2 - Representing and Interpreting Physical Quantities as Graphs")
# maths_as2.topics.create!(name: "Unit 17: Kinematics of Particles Moving in a Straight Line", time: 2, unit:"Topic 17.3 - Vertical Motion Under Gravity")
# maths_as2.topics.create!(name: "Unit 17: Kinematics of Particles Moving in a Straight Line", time: 1, unit:"MA: End of unit assessment 17")
# maths_as2.topics.create!(name: "Unit 18: Dynamics of Particles Moving in a Straight Line", time: 3, unit:"Topic 18.1 - Representing and Calculating Resultant Forces")
# maths_as2.topics.create!(name: "Unit 18: Dynamics of Particles Moving in a Straight Line", time: 4, unit:"Topic 18.2 - Newtons Second Law")
# maths_as2.topics.create!(name: "Unit 18: Dynamics of Particles Moving in a Straight Line", time: 4, unit:"Topic 18.3 - Frictional Forces")
# maths_as2.topics.create!(name: "Unit 18: Dynamics of Particles Moving in a Straight Line", time: 4, unit:"Topic 18.4 - Connected Particles and Smooth Pulleys")
# maths_as2.topics.create!(name: "Unit 18: Dynamics of Particles Moving in a Straight Line", time: 8, unit:"Topic 18.5 - Momentum, Impulse and Collisions in 1D")
# maths_as2.topics.create!(name: "Unit 18: Dynamics of Particles Moving in a Straight Line", time: 1, unit:"End of Unit Assement 18")
# maths_as2.topics.create!(name: "Unit 19: Statics", time: 4, unit:"Topic 19.1 - Static Equilibrium")
# maths_as2.topics.create!(name: "Unit 20: Rotational Effects of Forces", time: 7, unit:"Topic 20.1 - Moment of a Force and Rotational Equilibrium")
# maths_as2.topics.create!(name: "Unit 20: Rotational Effects of Forces", time: 1, unit:"End of Unit Assessment 20")
# maths_as2.topics.create!(name: "Course Revision Assessment & Exam Preparation", time: 5, unit:"Course Revision Assessment & Exam Preparation")
# maths_as2.topics.create!(name: "Warm up mock", time: 2, unit:"Warm up mock")
# maths_as2.topics.create!(name: "Mechanics - Paper 1 MOCK (AS Component)", time: 1.5, unit:"Mechanics - Paper 1 MOCK (AS Component)")



# testhub = Hub.create!(
#   name: "Test Hub",
#   country: "Portugal"
#   )

#   Hub.create!(
#     name: "Aveiro",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Bangalore (Micro)",
#     country: "India"
# )
# Hub.create!(
#     name: "Boca Raton",
#     country: "USA"
# )
# Hub.create!(
#     name: "Braga",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Caldas da Rainha",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Campolide",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Cascais 1",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Cascais 2",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Cascais Baía 1",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Cascais Baía 2",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "CCB",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Coimbra (Espinhal)",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Ericeira 1",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Ericeira 2",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Expo",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Funchal",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Fundão",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Guincho",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Kilifi",
#     country: "Kenya"
# )
# Hub.create!(
#     name: "Lagoa",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Lagos 1",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Lagos 2",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Leiria",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Loulé",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Lumiar",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Marbella",
#     country: "Spain"
# )
# Hub.create!(
#     name: "Nelspruit",
#     country: "South Africa"
# )
# Hub.create!(
#     name: "Óbidos",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Ofir",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Online",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Parede",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Phuket",
#     country: "Thailand"
# )
# Hub.create!(
#     name: "Porto Anje",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Porto Foco",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Quinta da Marinha",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Restelo",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Santarém",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Setúbal",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Sommerschield",
#     country: "Mozambique"
# )
# Hub.create!(
#     name: "Tábua",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Tavira",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Tofo",
#     country: "Mozambique"
# )
# Hub.create!(
#     name: "Tygervalley",
#     country: "South Africa"
# )
# Hub.create!(
#     name: "Valencia",
#     country: "Spain"
# )
# Hub.create!(
#     name: "Vila Sol",
#     country: "Portugal"
# )
# Hub.create!(
#     name: "Walvis Bay",
#     country: "Namibia"
# )
# Hub.create!(
#     name: "Windhoek",
#     country: "Namibia"
# )
# xico = User.create!(
#   email: "francisco-abf@hotmail.com",
#   password: "123456",
#   full_name: "Francisco Figueiredo",
#   role: "admin"
#   )

#   brito = User.create!(
#   email: "britoefaro@gmail.com",
#   password: "123456",
#   full_name: "Luis Brito e Faro",
#   role: "admin"
#   )

#   tester = User.create!(
#     email: "tester@tester.com",
#     password: "123456",
#     full_name: "Bug Catcher",
#     role: "admin"
#     )

#   tester_hub = UsersHub.create!(
#     user: tester,
#     hub: testhub
#     )

#   guest_lc = User.create!(
#     email: "guest@lc.com",
#     password: "123456",
#     full_name: "Guest LC",
#     role: "lc"
#     )


#   cascais_lc = User.create!(
#     email: "cascais@lc.com",
#     password: "123456",
#     full_name: "Cascais LC",
#     role: "lc"
#     )

#   UsersHub.create!(
#     user: cascais_lc,
#     hub: testhub
#     )

#       cascais_learner = User.create!(
#         email: "cascais@learner.com",
#         password: "123456",
#         full_name: "Guest 1",
#         role: "learner"
#         )

#         UsersHub.create!(
#           user: cascais_learner,
#           hub: testhub
#           )


# joe = User.create!(
#   email: "john@learner.com",
#   password: "123456",
#   full_name: "Joe King",
#   role: "learner"
#   )

# mary = User.create!(
#   email: "mary@learner.com",
#   password: "123456",
#   full_name: "Mary Queen",
#   role: "learner"
#   )

# manel = User.create!(
#   email: "manel@learner.com",
#   password: "123456",
#   full_name: "Manel Costa",
#   role: "learner"
#   )

# quim = User.create!(
#   email: "quim@learner.com",
#   password: "123456",
#   full_name: "Quim Barreiros",
#   role: "learner"
#   )


#   guest_lc  = UsersHub.create!(
#     user: guest_lc,
#     hub: testhub
#   )

#     xico_hub = UsersHub.create!(
#       user: xico,
#       hub: testhub
#       )
#     brito_hub = UsersHub.create!(
#       user: brito,
#       hub: testhub
#     )

#       mary_hub = UsersHub.create!(
#       user: mary,
#       hub: testhub
#       )

#       quim_hub = UsersHub.create!(
#       user: quim,
#       hub: testhub
#       )

#       Holiday.create!(
#         name: "Easter Break 2024",
#         start_date: "2024/03/25",
#         end_date: "2024/04/01",
#         bga: true
#       )

#       Holiday.create!(
#         name: "Easter Break 2024",
#         start_date: "2024/03/25",
#         end_date: "2024/04/01",
#         user: brito
#       )

#       Holiday.create!(
#         name: "Christmas Break 2024",
#         start_date: "2024/12/16",
#         end_date: "2025/01/02",
#         bga: true
#       )

      # sprint1 = Sprint.create!(
      #   name: "Sprint 1",
      #   start_date: "04/01/2024",
      #   end_date: "03/05/2024"
      # )

      # sprint2 = Sprint.create!(
      #   name: "Sprint 2",
      #   start_date: "06/05/2024",
      #   end_date: "30/08/2024"
      # )

      # sprint3 = Sprint.create!(
      #   name: "Sprint 3",
      #   start_date: "02/09/2024",
      #   end_date: "03/01/2025"
      # )

      # Week.create!(
      #   name: "Week 8",
      #   start_date: "19/02/2024",
      #   end_date: "23/02/2024",
      #   sprint: sprint1
      # )
      # Week.create!(
      #   name: "Week 9",
      #   start_date: "26/02/2024",
      #   end_date: "01/03/2024",
      #   sprint: sprint1
      # )
      # Week.create!(
      #   name: "Week 10",
      #   start_date: "04/03/2024",
      #   end_date: "08/03/2024",
      #   sprint: sprint1
      # )

      # Week.create!(
      #   name: "Week 11",
      #   start_date: "11/03/2024",
      #   end_date: "15/03/2024",
      #   sprint: sprint1
      # )

      # Week.create!(
      #   name: "Week 12",
      #   start_date: "18/03/2024",
      #   end_date: "22/03/2024",
      #   sprint: sprint1
      # )

      # Week.create!(
      #   name: "Week 13",
      #   start_date: "25/03/2024",
      #   end_date: "29/03/2024",
      #   sprint: sprint1
      # )

      # Week.create!(
      #   name: "Week 14",
      #   start_date: "01/04/2024",
      #   end_date: "05/04/2024",
      #   sprint: sprint1
      # )
      # Week.create!(
      #   name: "Week 15",
      #   start_date: "08/04/2024",
      #   end_date: "12/04/2024",
      #   sprint: sprint1
      # )

      # Week.create!(
      # name: "Week 16",
      # start_date: "15/04/2024",
      # end_date: "19/04/2024",
      # sprint: sprint1
      # )
      # Week.create!(
      # name: "Week 17",
      # start_date: "22/04/2024",
      # end_date: "26/04/2024",
      # sprint: sprint1
      # )
      # Week.create!(
      # name: "Week 18",
      # start_date: "29/04/2024",
      # end_date: "03/05/2024",
      # sprint: sprint1
      # )
      # Week.create!(
      # name: "Week 1",
      # start_date: "06/05/2024",
      # end_date: "10/05/2024",
      # sprint: sprint2
      # )
      # Week.create!(
      # name: "Week 2",
      # start_date: "13/05/2024",
      # end_date: "17/05/2024",
      # sprint: sprint2
      # )
      # Week.create!(
      # name: "Week 3",
      # start_date: "20/05/2024",
      # end_date: "24/05/2024",
      # sprint: sprint2
      # )
      # Week.create!(
      # name: "Week 4",
      # start_date: "27/05/2024",
      # end_date: "31/05/2024",
      # sprint: sprint2
      # )
      # Week.create!(
      # name: "Week 5",
      # start_date: "03/06/2024",
      # end_date: "07/06/2024",
      # sprint: sprint2
      # )
      # Week.create!(
      # name: "Week 6",
      # start_date: "10/06/2024",
      # end_date: "14/06/2024",
      # sprint: sprint2
      # )
      # Week.create!(
      # name: "Week 7",
      # start_date: "17/06/2024",
      # end_date: "21/06/2024",
      # sprint: sprint2
      # )
      # Week.create!(
      # name: "Week 8",
      # start_date: "24/06/2024",
      # end_date: "28/06/2024",
      # sprint: sprint2
      # )
      # Week.create!(
      # name: "Week 9",
      # start_date: "01/07/2024",
      # end_date: "05/07/2024",
      # sprint: sprint2
      # )
      # Week.create!(
      # name: "Week 10",
      # start_date: "08/07/2024",
      # end_date: "12/07/2024",
      # sprint: sprint2
      # )
      # Week.create!(
      # name: "Week 11",
      # start_date: "15/07/2024",
      # end_date: "19/07/2024",
      # sprint: sprint2
      # )
      # Week.create!(
      # name: "Week 12",
      # start_date: "22/07/2024",
      # end_date: "26/07/2024",
      # sprint: sprint2
      # )
      # Week.create!(
      # name: "Week 13",
      # start_date: "29/07/2024",
      # end_date: "02/08/2024",
      # sprint: sprint2
      # )
      # Week.create!(
      # name: "Week 14",
      # start_date: "05/08/2024",
      # end_date: "09/08/2024",
      # sprint: sprint2
      # )
      # Week.create!(
      # name: "Week 15",
      # start_date: "12/08/2024",
      # end_date: "16/08/2024",
      # sprint: sprint2
      # )
      # Week.create!(
      # name: "Week 16",
      # start_date: "19/08/2024",
      # end_date: "23/08/2024",
      # sprint: sprint2
      # )
      # Week.create!(
      # name: "Week 17",
      # start_date: "26/08/2024",
      # end_date: "30/08/2024",
      # sprint: sprint2
      # )
      # Week.create!(
      # name: "Week 1",
      # start_date: "02/09/2024",
      # end_date: "06/09/2024",
      # sprint: sprint3
      # )
      # Week.create!(
      # name: "Week 2",
      # start_date: "09/09/2024",
      # end_date: "13/09/2024",
      # sprint: sprint3
      # )
      # Week.create!(
      # name: "Week 3",
      # start_date: "16/09/2024",
      # end_date: "20/09/2024",
      # sprint: sprint3
      # )
      # Week.create!(
      # name: "Week 4",
      # start_date: "23/09/2024",
      # end_date: "27/09/2024",
      # sprint: sprint3
      # )
      # Week.create!(
      # name: "Week 5",
      # start_date: "30/09/2024",
      # end_date: "04/10/2024",
      # sprint: sprint3
      # )
      # Week.create!(
      # name: "Week 6",
      # start_date: "07/10/2024",
      # end_date: "11/10/2024",
      # sprint: sprint3
      # )
      # Week.create!(
      # name: "Week 7",
      # start_date: "14/10/2024",
      # end_date: "18/10/2024",
      # sprint: sprint3
      # )
      # Week.create!(
      # name: "Week 8",
      # start_date: "21/10/2024",
      # end_date: "25/10/2024",
      # sprint: sprint3
      # )
      # Week.create!(
      # name: "Week 9",
      # start_date: "28/10/2024",
      # end_date: "01/11/2024",
      # sprint: sprint3
      # )
      # Week.create!(
      # name: "Week 10",
      # start_date: "04/11/2024",
      # end_date: "08/11/2024",
      # sprint: sprint3
      # )
      # Week.create!(
      # name: "Week 11",
      # start_date: "11/11/2024",
      # end_date: "15/11/2024",
      # sprint: sprint3
      # )
      # Week.create!(
      # name: "Week 12",
      # start_date: "18/11/2024",
      # end_date: "22/11/2024",
      # sprint: sprint3
      # )
      # Week.create!(
      # name: "Week 13",
      # start_date: "25/11/2024",
      # end_date: "29/11/2024",
      # sprint: sprint3
      # )
      # Week.create!(
      # name: "Week 14",
      # start_date: "02/12/2024",
      # end_date: "06/12/2024",
      # sprint: sprint3
      # )
      # Week.create!(
      # name: "Week 15",
      # start_date: "09/12/2024",
      # end_date: "13/12/2024",
      # sprint: sprint3
      # )
      # Week.create!(
      # name: "Week 16",
      # start_date: "16/12/2024",
      # end_date: "20/12/2024",
      # sprint: sprint3
      # )

# sprint13 = Sprint.create!(name: "Sprint 1", start_date: "04/01/2025", end_date: "02/05/2025")
# sprint14 =Sprint.create!(name: "Sprint 2", start_date: "05/05/2025", end_date: "30/08/2025")
# sprint15 = Sprint.create!(name: "Sprint 3", start_date: "02/09/2025", end_date: "03/01/2026")
# sprint16 = Sprint.create!(name: "Sprint 1", start_date: "06/01/2026", end_date: "04/05/2026")
# sprint17 = Sprint.create!(name: "Sprint 2", start_date: "07/05/2026", end_date: "30/08/2026")
# sprint18 = Sprint.create!(name: "Sprint 3", start_date: "02/09/2026", end_date: "03/01/2027")
# sprint19 = Sprint.create!(name: "Sprint 1", start_date: "06/01/2027", end_date: "03/05/2027")
# sprint20 = Sprint.create!(name: "Sprint 2", start_date: "06/05/2027", end_date: "30/08/2027")
# sprint21 = Sprint.create!(name: "Sprint 3", start_date: "02/09/2027", end_date: "03/01/2028")

# Week.create!(
#   name: "Week 1",
#   start_date: "06/01/2025",
#   end_date: "10/01/2025",
#   sprint: sprint13
# )
# Week.create!(
#   name: "Week 2",
#   start_date: "13/01/2025",
#   end_date: "17/01/2025",
#   sprint: sprint13
# )
# Week.create!(
#   name: "Week 3",
#   start_date: "20/01/2025",
#   end_date: "24/01/2025",
#   sprint: sprint13
# )
# Week.create!(
#   name: "Week 4",
#   start_date: "27/01/2025",
#   end_date: "31/01/2025",
#   sprint: sprint13
# )
# Week.create!(
#   name: "Week 5",
#   start_date: "03/02/2025",
#   end_date: "07/02/2025",
#   sprint: sprint13
# )
# Week.create!(
#   name: "Week 6",
#   start_date: "10/02/2025",
#   end_date: "14/02/2025",
#   sprint: sprint13
# )
# Week.create!(
#   name: "Week 7",
#   start_date: "17/02/2025",
#   end_date: "21/02/2025",
#   sprint: sprint13
# )
# Week.create!(
#   name: "Week 8",
#   start_date: "24/02/2025",
#   end_date: "28/02/2025",
#   sprint: sprint13
# )
# Week.create!(
#   name: "Week 9",
#   start_date: "03/03/2025",
#   end_date: "07/03/2025",
#   sprint: sprint13
# )
# Week.create!(
#   name: "Week 10",
#   start_date: "10/03/2025",
#   end_date: "14/03/2025",
#   sprint: sprint13
# )
# Week.create!(
#   name: "Week 11",
#   start_date: "17/03/2025",
#   end_date: "21/03/2025",
#   sprint: sprint13
# )
# Week.create!(
#   name: "Week 12",
#   start_date: "24/03/2025",

#   end_date: "28/03/2025",
#   sprint: sprint13
# )
# Week.create!(
#   name: "Week 13",
#   start_date: "31/03/2025",
#   end_date: "04/04/2025",
#   sprint: sprint13
# )
# Week.create!(
#   name: "Week 14",
#   start_date: "07/04/2025",
#   end_date: "11/04/2025",
#   sprint: sprint13
# )
# Week.create!(
#   name: "Week 15",
#   start_date: "14/04/2025",
#   end_date: "18/04/2025",
#   sprint: sprint13
# )
# Week.create!(
#   name: "Week 16",
#   start_date: "21/04/2025",
#   end_date: "25/04/2025",
#   sprint: sprint13
# )
# Week.create!(
#   name: "Week 17",
#   start_date: "28/04/2025",
#   end_date: "02/05/2025",
#   sprint: sprint13
# )
# Week.create!(
#   name: "Week 1",
#   start_date: "05/05/2025",
#   end_date: "09/05/2025",
#   sprint: sprint14
# )
# Week.create!(
#   name: "Week 2",
#   start_date: "12/05/2025",
#   end_date: "16/05/2025",
#   sprint: sprint14
# )
# Week.create!(
#   name: "Week 3",
#   start_date: "19/05/2025",
#   end_date: "23/05/2025",
#   sprint: sprint14
# )
# Week.create!(
#   name: "Week 4",
#   start_date: "26/05/2025",
#   end_date: "30/05/2025",
#   sprint: sprint14
# )
# Week.create!(
#   name: "Week 5",
#   start_date: "02/06/2025",
#   end_date: "06/06/2025",
#   sprint: sprint14
# )
# Week.create!(
#   name: "Week 6",
#   start_date: "09/06/2025",
#   end_date: "13/06/2025",
#   sprint: sprint14
# )
# Week.create!(
#   name: "Week 7",
#   start_date: "16/06/2025",
#   end_date: "20/06/2025",
#   sprint: sprint14
# )
# Week.create!(
#   name: "Week 8",
#   start_date: "23/06/2025",
#   end_date: "27/06/2025",
#   sprint: sprint14
# )
# Week.create!(
#   name: "Week 9",
#   start_date: "30/06/2025",
#   end_date: "04/07/2025",
#   sprint: sprint14
# )
# Week.create!(
#   name: "Week 10",
#   start_date: "07/07/2025",
#   end_date: "11/07/2025",
#   sprint: sprint14
# )
# Week.create!(
#   name: "Week 11",
#   start_date: "14/07/2025",
#   end_date: "18/07/2025",
#   sprint: sprint14
# )
# Week.create!(
#   name: "Week 12",
#   start_date: "21/07/2025",
#   end_date: "25/07/2025",
#   sprint: sprint14
# )
# Week.create!(
#   name: "Week 13",
#   start_date: "28/07/2025",
#   end_date: "01/08/2025",
#   sprint: sprint14
# )
# Week.create!(
#   name: "Week 14",
#   start_date: "04/08/2025",
#   end_date: "08/08/2025",
#   sprint: sprint14
# )
# Week.create!(
#   name: "Week 15",
#   start_date: "11/08/2025",
#   end_date: "15/08/2025",
#   sprint: sprint14
# )
# Week.create!(
#   name: "Week 16",
#   start_date: "18/08/2025",
#   end_date: "22/08/2025",
#   sprint: sprint14
# )
# Week.create!(
#   name: "Week 17",
#   start_date: "25/08/2025",
#   end_date: "29/08/2025",
#   sprint: sprint14
# )
# Week.create!(
#   name: "Week 1",
#   start_date: "01/09/2025",
#   end_date: "05/09/2025",
#   sprint: sprint15
# )
# Week.create!(
#   name: "Week 2",
#   start_date: "08/09/2025",
#   end_date: "12/09/2025",
#   sprint: sprint15
# )
# Week.create!(
#   name: "Week 3",
#   start_date: "15/09/2025",
#   end_date: "19/09/2025",
#   sprint: sprint15
# )
# Week.create!(
#   name: "Week 4",
#   start_date: "22/09/2025",
#   end_date: "26/09/2025",
#   sprint: sprint15
# )
# Week.create!(
#   name: "Week 5",
#   start_date: "29/09/2025",
#   end_date: "03/10/2025",
#   sprint: sprint15
# )
# Week.create!(
#   name: "Week 6",
#   start_date: "06/10/2025",
#   end_date: "10/10/2025",
#   sprint: sprint15
# )
# Week.create!(
#   name: "Week 7",
#   start_date: "13/10/2025",
#   end_date: "17/10/2025",
#   sprint: sprint15
# )
# Week.create!(
#   name: "Week 8",
#   start_date: "20/10/2025",
#   end_date: "24/10/2025",
#   sprint: sprint15
# )
# Week.create!(
#   name: "Week 9",
#   start_date: "27/10/2025",
#   end_date: "31/10/2025",
#   sprint: sprint15
# )
# Week.create!(
#   name: "Week 10",
#   start_date: "03/11/2025",
#   end_date: "07/11/2025",
#   sprint: sprint15
# )
# Week.create!(
#   name: "Week 11",
#   start_date: "10/11/2025",
#   end_date: "14/11/2025",
#   sprint: sprint15
# )
# Week.create!(name: "Week 12", start_date: "17/11/2025", end_date: "21/11/2025", sprint: sprint15)
# Week.create!(name: "Week 13", start_date: "24/11/2025", end_date: "28/11/2025", sprint: sprint15)
# Week.create!(name: "Week 14", start_date: "01/12/2025", end_date: "05/12/2025", sprint: sprint15)
# Week.create!(name: "Week 15", start_date: "08/12/2025", end_date: "12/12/2025", sprint: sprint15)
# Week.create!(name: "Week 16", start_date: "15/12/2025", end_date: "19/12/2025", sprint: sprint15)
# Week.create!(name: "Week 17", start_date: "22/12/2025", end_date: "26/12/2025", sprint: sprint15)
# Week.create!(name: "Week 18", start_date: "29/12/2025", end_date: "02/01/2026", sprint: sprint15)
# Week.create!(name: "Week 1", start_date: "05/01/2026", end_date: "09/01/2026", sprint: sprint16)
# Week.create!(name: "Week 2", start_date: "12/01/2026", end_date: "16/01/2026", sprint: sprint16)
# Week.create!(name: "Week 3", start_date: "19/01/2026", end_date: "23/01/2026", sprint: sprint16)
# Week.create!(name: "Week 4", start_date: "26/01/2026", end_date: "30/01/2026", sprint: sprint16)
# Week.create!(name: "Week 5", start_date: "02/02/2026", end_date: "06/02/2026", sprint: sprint16)
# Week.create!(name: "Week 6", start_date: "09/02/2026", end_date: "13/02/2026", sprint: sprint16)
# Week.create!(name: "Week 7", start_date: "16/02/2026", end_date: "20/02/2026", sprint: sprint16)
# Week.create!(name: "Week 8", start_date: "23/02/2026", end_date: "27/02/2026", sprint: sprint16)
# Week.create!(name: "Week 9", start_date: "02/03/2026", end_date: "06/03/2026", sprint: sprint16)
# Week.create!(name: "Week 10", start_date: "09/03/2026", end_date: "13/03/2026", sprint: sprint16)
# Week.create!(name: "Week 11", start_date: "16/03/2026", end_date: "20/03/2026", sprint: sprint16)
# Week.create!(name: "Week 12", start_date: "23/03/2026", end_date: "27/03/2026", sprint: sprint16)
# Week.create!(name: "Week 13", start_date: "30/03/2026", end_date: "03/04/2026", sprint: sprint16)
# Week.create!(name: "Week 14", start_date: "06/04/2026", end_date: "10/04/2026", sprint: sprint16)
# Week.create!(name: "Week 15", start_date: "13/04/2026", end_date: "17/04/2026", sprint: sprint16)
# Week.create!(name: "Week 16", start_date: "20/04/2026", end_date: "24/04/2026", sprint: sprint16)
# Week.create!(name: "Week 17", start_date: "27/04/2026", end_date: "01/05/2026", sprint: sprint16)
# Week.create!(name: "Week 1", start_date: "04/05/2026", end_date: "08/05/2026", sprint: sprint17)
# Week.create!(name: "Week 2", start_date: "11/05/2026", end_date: "15/05/2026", sprint: sprint17)
# Week.create!(name: "Week 3", start_date: "18/05/2026", end_date: "22/05/2026", sprint: sprint17)
# Week.create!(name: "Week 4", start_date: "25/05/2026", end_date: "29/05/2026", sprint: sprint17)
# Week.create!(name: "Week 5", start_date: "01/06/2026", end_date: "05/06/2026", sprint: sprint17)
# Week.create!(name: "Week 6", start_date: "08/06/2026", end_date: "12/06/2026", sprint: sprint17)
# Week.create!(name: "Week 7", start_date: "15/06/2026", end_date: "19/06/2026", sprint: sprint17)
# Week.create!(name: "Week 8", start_date: "22/06/2026", end_date: "26/06/2026", sprint: sprint17)
# Week.create!(name: "Week 9", start_date: "29/06/2026", end_date: "03/07/2026", sprint: sprint17)
# Week.create!(name: "Week 10", start_date: "06/07/2026", end_date: "10/07/2026", sprint: sprint17)
# Week.create!(name: "Week 11", start_date: "13/07/2026", end_date: "17/07/2026", sprint: sprint17)
# Week.create!(name: "Week 12", start_date: "20/07/2026", end_date: "24/07/2026", sprint: sprint17)
# Week.create!(name: "Week 13", start_date: "27/07/2026", end_date: "31/07/2026", sprint: sprint17)
# Week.create!(name: "Week 14", start_date: "03/08/2026", end_date: "07/08/2026", sprint: sprint17)
# Week.create!(name: "Week 15", start_date: "10/08/2026", end_date: "14/08/2026", sprint: sprint17)
# Week.create!(name: "Week 16", start_date: "17/08/2026", end_date: "21/08/2026", sprint: sprint17)
# Week.create!(name: "Week 17", start_date: "24/08/2026", end_date: "28/08/2026", sprint: sprint17)
# Week.create!(name: "Week 1", start_date: "31/08/2026", end_date: "04/09/2026", sprint: sprint18)
# Week.create!(name: "Week 2", start_date: "07/09/2026", end_date: "11/09/2026", sprint: sprint18)
# Week.create!(name: "Week 3", start_date: "14/09/2026", end_date: "18/09/2026", sprint: sprint18)
# Week.create!(name: "Week 4", start_date: "21/09/2026", end_date: "25/09/2026", sprint: sprint18)
# Week.create!(name: "Week 5", start_date: "28/09/2026", end_date: "02/10/2026", sprint: sprint18)
# Week.create!(name: "Week 6", start_date: "05/10/2026", end_date: "09/10/2026", sprint: sprint18)
# Week.create!(name: "Week 7", start_date: "12/10/2026", end_date: "16/10/2026", sprint: sprint18)
# Week.create!(name: "Week 8", start_date: "19/10/2026", end_date: "23/10/2026", sprint: sprint18)
# Week.create!(name: "Week 9", start_date: "26/10/2026", end_date: "30/10/2026", sprint: sprint18)
# Week.create!(name: "Week 10", start_date: "02/11/2026", end_date: "06/11/2026", sprint: sprint18)
# Week.create!(name: "Week 11", start_date: "09/11/2026", end_date: "13/11/2026", sprint: sprint18)
# Week.create!(name: "Week 12", start_date: "16/11/2026", end_date: "20/11/2026", sprint: sprint18)
# Week.create!(name: "Week 13", start_date: "23/11/2026", end_date: "27/11/2026", sprint: sprint18)
# Week.create!(name: "Week 14", start_date: "30/11/2026", end_date: "04/12/2026", sprint: sprint18)
# Week.create!(name: "Week 15", start_date: "07/12/2026", end_date: "11/12/2026", sprint: sprint18)
# Week.create!(name: "Week 16", start_date: "14/12/2026", end_date: "18/12/2026", sprint: sprint18)
# Week.create!(name: "Week 17", start_date: "21/12/2026", end_date: "25/12/2026", sprint: sprint18)
# Week.create!(name: "Week 18", start_date: "28/12/2026", end_date: "01/01/2027", sprint: sprint18)
# Week.create!(name: "Week 1", start_date: "04/01/2027", end_date: "08/01/2027", sprint: sprint19)
# Week.create!(name: "Week 2", start_date: "11/01/2027", end_date: "15/01/2027", sprint: sprint19)
# Week.create!(name: "Week 3", start_date: "18/01/2027", end_date: "22/01/2027", sprint: sprint19)
# Week.create!(name: "Week 4", start_date: "25/01/2027", end_date: "29/01/2027", sprint: sprint19)
# Week.create!(name: "Week 5", start_date: "01/02/2027", end_date: "05/02/2027", sprint: sprint19)
# Week.create!(name: "Week 6", start_date: "08/02/2027", end_date: "12/02/2027", sprint: sprint19)
# Week.create!(name: "Week 7", start_date: "15/02/2027", end_date: "19/02/2027", sprint: sprint19)
# Week.create!(name: "Week 8", start_date: "22/02/2027", end_date: "26/02/2027", sprint: sprint19)
# Week.create!(name: "Week 9", start_date: "01/03/2027", end_date: "05/03/2027", sprint: sprint19)
# Week.create!(name: "Week 10", start_date: "08/03/2027", end_date: "12/03/2027", sprint: sprint19)
# Week.create!(name: "Week 11", start_date: "15/03/2027", end_date: "19/03/2027", sprint: sprint19)
# Week.create!(name: "Week 12", start_date: "22/03/2027", end_date: "26/03/2027", sprint: sprint19)
# Week.create!(name: "Week 13", start_date: "29/03/2027", end_date: "02/04/2027", sprint: sprint19)
# Week.create!(name: "Week 14", start_date: "05/04/2027", end_date: "09/04/2027", sprint: sprint19)
# Week.create!(name: "Week 15", start_date: "12/04/2027", end_date: "16/04/2027", sprint: sprint19)
# Week.create!(name: "Week 16", start_date: "19/04/2027", end_date: "23/04/2027", sprint: sprint19)
# Week.create!(name: "Week 17", start_date: "26/04/2027", end_date: "30/04/2027", sprint: sprint19)
# Week.create!(name: "Week 1", start_date: "03/05/2027", end_date: "07/05/2027", sprint: sprint20)
# Week.create!(name: "Week 2", start_date: "10/05/2027", end_date: "14/05/2027", sprint: sprint20)
# Week.create!(name: "Week 3", start_date: "17/05/2027", end_date: "21/05/2027", sprint: sprint20)
# Week.create!(name: "Week 4", start_date: "24/05/2027", end_date: "28/05/2027", sprint: sprint20)
# Week.create!(name: "Week 5", start_date: "31/05/2027", end_date: "04/06/2027", sprint: sprint20)
# Week.create!(name: "Week 6", start_date: "07/06/2027", end_date: "11/06/2027", sprint: sprint20)
# Week.create!(name: "Week 7", start_date: "14/06/2027", end_date: "18/06/2027", sprint: sprint20)
# Week.create!(name: "Week 8", start_date: "21/06/2027", end_date: "25/06/2027", sprint: sprint20)
# Week.create!(name: "Week 9", start_date: "28/06/2027", end_date: "02/07/2027", sprint: sprint20)
# Week.create!(name: "Week 10", start_date: "05/07/2027", end_date: "09/07/2027", sprint: sprint20)
# Week.create!(name: "Week 11", start_date: "12/07/2027", end_date: "16/07/2027", sprint: sprint20)
# Week.create!(name: "Week 12", start_date: "19/07/2027", end_date: "23/07/2027", sprint: sprint20)
# Week.create!(name: "Week 13", start_date: "26/07/2027", end_date: "30/07/2027", sprint: sprint20)
# Week.create!(name: "Week 14", start_date: "02/08/2027", end_date: "06/08/2027", sprint: sprint20)
# Week.create!(name: "Week 15", start_date: "09/08/2027", end_date: "13/08/2027", sprint: sprint20)
# Week.create!(name: "Week 16", start_date: "16/08/2027", end_date: "20/08/2027", sprint: sprint20)
# Week.create!(name: "Week 17", start_date: "23/08/2027", end_date: "27/08/2027", sprint: sprint20)
# Week.create!(name: "Week 1", start_date: "30/08/2027", end_date: "03/09/2027", sprint: sprint21)
# Week.create!(name: "Week 2", start_date: "06/09/2027", end_date: "10/09/2027", sprint: sprint21)
# Week.create!(name: "Week 3", start_date: "13/09/2027", end_date: "17/09/2027", sprint: sprint21)
# Week.create!(name: "Week 4", start_date: "20/09/2027", end_date: "24/09/2027", sprint: sprint21)
# Week.create!(name: "Week 5", start_date: "27/09/2027", end_date: "01/10/2027", sprint: sprint21)
# Week.create!(name: "Week 6", start_date: "04/10/2027", end_date: "08/10/2027", sprint: sprint21)
# Week.create!(name: "Week 7", start_date: "11/10/2027", end_date: "15/10/2027", sprint: sprint21)
# Week.create!(name: "Week 8", start_date: "18/10/2027", end_date: "22/10/2027", sprint: sprint21)
# Week.create!(name: "Week 9", start_date: "25/10/2027", end_date: "29/10/2027", sprint: sprint21)
# Week.create!(name: "Week 10", start_date: "01/11/2027", end_date: "05/11/2027", sprint: sprint21)
# Week.create!(name: "Week 11", start_date: "08/11/2027", end_date: "12/11/2027", sprint: sprint21)
# Week.create!(name: "Week 12", start_date: "15/11/2027", end_date: "19/11/2027", sprint: sprint21)
# Week.create!(name: "Week 13", start_date: "22/11/2027", end_date: "26/11/2027", sprint: sprint21)
# Week.create!(name: "Week 14", start_date: "29/11/2027", end_date: "03/12/2027", sprint: sprint21)
# Week.create!(name: "Week 15", start_date: "06/12/2027", end_date: "10/12/2027", sprint: sprint21)
# Week.create!(name: "Week 16", start_date: "13/12/2027", end_date: "17/12/2027", sprint: sprint21)
# Week.create!(name: "Week 17", start_date: "20/12/2027", end_date: "24/12/2027", sprint: sprint21)
# Week.create!(name: "Week 18", start_date: "27/12/2027", end_date: "31/12/2027", sprint: sprint21)

# Holiday.create!(name: "Build Week Sprint 1 / 2024", start_date: "26/02/2024", end_date: "01/03/2024", bga: true)
# Holiday.create!(name: "Build Week Sprint 2 / 2024", start_date: "24/06/2024", end_date: "28/06/2024", bga: true)
# Holiday.create!(name: "Build Week Sprint 3 / 2024", start_date: "28/10/2024", end_date: "01/11/2024", bga: true)
# Holiday.create!(name: "Easter Break 2024", start_date: "25/03/2024", end_date: "01/04/2024", bga: true)
# Holiday.create!(name: "Christmas Break 2024", start_date: "16/12/2024", end_date: "02/01/2025", bga: true)
# Holiday.create!(name: "Build Week Sprint 1 / 2025", start_date: "24/02/2025", end_date: "28/02/2025", bga: true)
# Holiday.create!(name: "Build Week Sprint 2 / 2025", start_date: "23/06/2025", end_date: "27/06/2025", bga: true)
# Holiday.create!(name: "Build Week Sprint 3 / 2025", start_date: "27/10/2025", end_date: "31/10/2025", bga: true)
# Holiday.create!(name: "Easter Break 2025", start_date: "20/04/2025", end_date: "24/04/2025", bga: true)
# Holiday.create!(name: "Christmas Break 2025", start_date: "22/12/2025", end_date: "29/12/2025", bga: true)
# Holiday.create!(name: "Build Week Sprint 1 / 2026", start_date: "23/02/2026", end_date: "27/02/2026", bga: true)
# Holiday.create!(name: "Build Week Sprint 2 / 2026", start_date: "29/06/2026", end_date: "03/07/2026", bga: true)
# Holiday.create!(name: "Build Week Sprint 3 / 2026", start_date: "26/10/2026", end_date: "30/10/2026", bga: true)
# Holiday.create!(name: "Easter Break 2026", start_date: "30/03/2026", end_date: "03/04/2026", bga: true)
# Holiday.create!(name: "Christmas Break 2026", start_date: "23/12/2026", end_date: "03/01/2027", bga: true)
# Holiday.create!(name: "Build Week Sprint 1 / 2027", start_date: "22/02/2027", end_date: "26/02/2027", bga: true)
# Holiday.create!(name: "Build Week Sprint 2 / 2027", start_date: "28/06/2027", end_date: "02/07/2027", bga: true)
# Holiday.create!(name: "Build Week Sprint 3 / 2027", start_date: "25/10/2027", end_date: "29/10/2027", bga: true)
# Holiday.create!(name: "Easter Break 2027", start_date: "22/03/2027", end_date: "26/04/2027", bga: true)
# Holiday.create!(name: "Christmas Break 2027", start_date: "20/12/2027", end_date: "31/12/2027", bga: true)

# Portugal
# Holiday.create!(name: "Dia de Ano Novo", start_date: "01/01/2024", end_date: "01/01/2024", country: "Portugal")
# Holiday.create!(name: "Dia da Liberdade", start_date: "25/04/2024", end_date: "25/04/2024", country: "Portugal")
# Holiday.create!(name: "Dia do Trabalhador", start_date: "01/05/2024", end_date: "01/05/2024", country: "Portugal")
# Holiday.create!(name: "Corpo de Deus", start_date: "30/05/2024", end_date: "30/05/2024", country: "Portugal")
# Holiday.create!(name: "Dia de Portugal", start_date: "10/06/2024", end_date: "10/06/2024", country: "Portugal")
# Holiday.create!(name: "Assunção de Nossa Senhora", start_date: "15/08/2024", end_date: "15/08/2024", country: "Portugal")
# Holiday.create!(name: "Implantação da República", start_date: "05/10/2024", end_date: "05/10/2024", country: "Portugal")
# Holiday.create!(name: "Dia de todos os santos", start_date: "01/11/2024", end_date: "01/11/2024", country: "Portugal")
# Holiday.create!(name: "Restauração da Independência", start_date: "01/12/2024", end_date: "01/12/2024", country: "Portugal")
# Holiday.create!(name: "Dia da Imaculada Conceição", start_date: "08/12/2024", end_date: "08/12/2024", country: "Portugal")
# Holiday.create!(name: "Dia de Ano Novo", start_date: "01/01/2025", end_date: "01/01/2025", country: "Portugal")
# Holiday.create!(name: "Dia da Liberdade", start_date: "25/04/2025", end_date: "25/04/2025", country: "Portugal")
# Holiday.create!(name: "Dia do Trabalhador", start_date: "01/05/2025", end_date: "01/05/2025", country: "Portugal")
# Holiday.create!(name: "Corpo de Deus", start_date: "30/05/2025", end_date: "30/05/2025", country: "Portugal")
# Holiday.create!(name: "Dia de Portugal", start_date: "10/06/2025", end_date: "10/06/2025", country: "Portugal")
# Holiday.create!(name: "Assunção de Nossa Senhora", start_date: "15/08/2025", end_date: "15/08/2025", country: "Portugal")
# Holiday.create!(name: "Implantação da República", start_date: "05/10/2025", end_date: "05/10/2025", country: "Portugal")
# Holiday.create!(name: "Dia de todos os santos", start_date: "01/11/2025", end_date: "01/11/2025", country: "Portugal")
# Holiday.create!(name: "Restauração da Independência", start_date: "01/12/2025", end_date: "01/12/2025", country: "Portugal")
# Holiday.create!(name: "Dia da Imaculada Conceição", start_date: "08/12/2025", end_date: "08/12/2025", country: "Portugal")
# Holiday.create!(name: "Dia de Ano Novo", start_date: "01/01/2026", end_date: "01/01/2026", country: "Portugal")
# Holiday.create!(name: "Dia da Liberdade", start_date: "25/04/2026", end_date: "25/04/2026", country: "Portugal")
# Holiday.create!(name: "Dia do Trabalhador", start_date: "01/05/2026", end_date: "01/05/2026", country: "Portugal")
# Holiday.create!(name: "Corpo de Deus", start_date: "30/05/2026", end_date: "30/05/2026", country: "Portugal")
# Holiday.create!(name: "Dia de Portugal", start_date: "10/06/2026", end_date: "10/06/2026", country: "Portugal")
# Holiday.create!(name: "Assunção de Nossa Senhora", start_date: "15/08/2026", end_date: "15/08/2026", country: "Portugal")
# Holiday.create!(name: "Implantação da República", start_date: "05/10/2026", end_date: "05/10/2026", country: "Portugal")
# Holiday.create!(name: "Dia de todos os santos", start_date: "01/11/2026", end_date: "01/11/2026", country: "Portugal")
# Holiday.create!(name: "Restauração da Independência", start_date: "01/12/2026", end_date: "01/12/2026", country: "Portugal")
# Holiday.create!(name: "Dia da Imaculada Conceição", start_date: "08/12/2026", end_date: "08/12/2026", country: "Portugal")
# Holiday.create!(name: "Dia de Ano Novo", start_date: "01/01/2027", end_date: "01/01/2027", country: "Portugal")
# Holiday.create!(name: "Dia da Liberdade", start_date: "25/04/2027", end_date: "25/04/2027", country: "Portugal")
# Holiday.create!(name: "Dia do Trabalhador", start_date: "01/05/2027", end_date: "01/05/2027", country: "Portugal")
# Holiday.create!(name: "Corpo de Deus", start_date: "30/05/2027", end_date: "30/05/2027", country: "Portugal")
# Holiday.create!(name: "Dia de Portugal", start_date: "10/06/2027", end_date: "10/06/2027", country: "Portugal")
# Holiday.create!(name: "Assunção de Nossa Senhora", start_date: "15/08/2027", end_date: "15/08/2027", country: "Portugal")
# Holiday.create!(name: "Implantação da República", start_date: "05/10/2027", end_date: "05/10/2027", country: "Portugal")
# Holiday.create!(name: "Dia de todos os santos", start_date: "01/11/2027", end_date: "01/11/2027", country: "Portugal")
# Holiday.create!(name: "Restauração da Independência", start_date: "01/12/2027", end_date: "01/12/2027", country: "Portugal")
# Holiday.create!(name: "Dia da Imaculada Conceição", start_date: "08/12/2027", end_date: "08/12/2027", country: "Portugal")
# Holiday.create!(name: "Dia de Ano Novo", start_date: "01/01/2028", end_date: "01/01/2028", country: "Portugal")
# Holiday.create!(name: "Dia da Liberdade", start_date: "25/04/2028", end_date: "25/04/2028", country: "Portugal")
# Holiday.create!(name: "Dia do Trabalhador", start_date: "01/05/2028", end_date: "01/05/2028", country: "Portugal")
# Holiday.create!(name: "Corpo de Deus", start_date: "30/05/2028", end_date: "30/05/2028", country: "Portugal")
# Holiday.create!(name: "Dia de Portugal", start_date: "10/06/2028", end_date: "10/06/2028", country: "Portugal")
# Holiday.create!(name: "Assunção de Nossa Senhora", start_date: "15/08/2028", end_date: "15/08/2028", country: "Portugal")
# Holiday.create!(name: "Implantação da República", start_date: "05/10/2028", end_date: "05/10/2028", country: "Portugal")
# Holiday.create!(name: "Dia de todos os santos", start_date: "01/11/2028", end_date: "01/11/2028", country: "Portugal")
# Holiday.create!(name: "Restauração da Independência", start_date: "01/12/2028", end_date: "01/12/2028", country: "Portugal")
# Holiday.create!(name: "Dia da Imaculada Conceição", start_date: "08/12/2028", end_date: "08/12/2028", country: "Portugal")

#Mozambique
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2024", end_date: "01/01/2024", country: "Mozambique")
# Holiday.create!(name: "Mozambican Heroe's Day", start_date: "03/02/2024", end_date: "03/02/2024", country: "Mozambique")
# Holiday.create!(name: "Mozambican’s Woman’s Day", start_date: "07/05/2024", end_date: "07/05/2024", country: "Mozambique")
# Holiday.create!(name: "Independence Day", start_date: "25/07/2024", end_date: "25/07/2024", country: "Mozambique")
# Holiday.create!(name: "Victory Day", start_date: "07/09/2024", end_date: "07/09/2024", country: "Mozambique")
# Holiday.create!(name: "Armed Forces Day", start_date: "25/09/2024", end_date: "25/09/2024", country: "Mozambique")
# Holiday.create!(name: "Peace and Reconciliation Day", start_date: "04/10/2024", end_date: "04/10/2024", country: "Mozambique")
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2025", end_date: "01/01/2025", country: "Mozambique")
# Holiday.create!(name: "Mozambican Heroe's Day", start_date: "03/02/2025", end_date: "03/02/2025", country: "Mozambique")
# Holiday.create!(name: "Mozambican’s Woman’s Day", start_date: "07/05/2025", end_date: "07/05/2025", country: "Mozambique")
# Holiday.create!(name: "Independence Day", start_date: "25/07/2025", end_date: "25/07/2025", country: "Mozambique")
# Holiday.create!(name: "Victory Day", start_date: "07/09/2025", end_date: "07/09/2025", country: "Mozambique")
# Holiday.create!(name: "Armed Forces Day", start_date: "25/09/2025", end_date: "25/09/2025", country: "Mozambique")
# Holiday.create!(name: "Peace and Reconciliation Day", start_date: "04/10/2025", end_date: "04/10/2025", country: "Mozambique")
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2026", end_date: "01/01/2026", country: "Mozambique")
# Holiday.create!(name: "Mozambican Heroe's Day", start_date: "03/02/2026", end_date: "03/02/2026", country: "Mozambique")
# Holiday.create!(name: "Mozambican’s Woman’s Day", start_date: "07/05/2026", end_date: "07/05/2026", country: "Mozambique")
# Holiday.create!(name: "Independence Day", start_date: "25/07/2026", end_date: "25/07/2026", country: "Mozambique")
# Holiday.create!(name: "Victory Day", start_date: "07/09/2026", end_date: "07/09/2026", country: "Mozambique")
# Holiday.create!(name: "Armed Forces Day", start_date: "25/09/2026", end_date: "25/09/2026", country: "Mozambique")
# Holiday.create!(name: "Peace and Reconciliation Day", start_date: "04/10/2026", end_date: "04/10/2026", country: "Mozambique")
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2027", end_date: "01/01/2027", country: "Mozambique")
# Holiday.create!(name: "Mozambican Heroe's Day", start_date: "03/02/2027", end_date: "03/02/2027", country: "Mozambique")
# Holiday.create!(name: "Mozambican’s Woman’s Day", start_date: "07/05/2027", end_date: "07/05/2027", country: "Mozambique")
# Holiday.create!(name: "Independence Day", start_date: "25/07/2027", end_date: "25/07/2027", country: "Mozambique")
# Holiday.create!(name: "Victory Day", start_date: "07/09/2027", end_date: "07/09/2027", country: "Mozambique")
# Holiday.create!(name: "Armed Forces Day", start_date: "25/09/2027", end_date: "25/09/2027", country: "Mozambique")
# Holiday.create!(name: "Peace and Reconciliation Day", start_date: "04/10/2027", end_date: "04/10/2027", country: "Mozambique")
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2028", end_date: "01/01/2028", country: "Mozambique")
# Holiday.create!(name: "Mozambican Heroe's Day", start_date: "03/02/2028", end_date: "03/02/2028", country: "Mozambique")
# Holiday.create!(name: "Mozambican’s Woman’s Day", start_date: "07/05/2028", end_date: "07/05/2028", country: "Mozambique")
# Holiday.create!(name: "Independence Day", start_date: "25/07/2028", end_date: "25/07/2028", country: "Mozambique")
# Holiday.create!(name: "Victory Day", start_date: "07/09/2028", end_date: "07/09/2028", country: "Mozambique")
# Holiday.create!(name: "Armed Forces Day", start_date: "25/09/2028", end_date: "25/09/2028", country: "Mozambique")
# Holiday.create!(name: "Peace and Reconciliation Day", start_date: "04/10/2028", end_date: "04/10/2028", country: "Mozambique")

# #Namibia
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2024", end_date: "01/01/2024", country: "Namibia")
# Holiday.create!(name: "Independence Day", start_date: "21/03/2024", end_date: "21/03/2024", country: "Namibia")
# Holiday.create!(name: "Good Friday", start_date: "29/03/2024", end_date: "29/03/2024", country: "Namibia")
# Holiday.create!(name: "Workers' Day", start_date: "01/05/2024", end_date: "01/05/2024", country: "Namibia")
# Holiday.create!(name: "Cassinga Day", start_date: "04/05/2024", end_date: "04/05/2024", country: "Namibia")
# Holiday.create!(name: "Ascension Day", start_date: "09/05/2024", end_date: "09/05/2024", country: "Namibia")
# Holiday.create!(name: "Africa Day", start_date: "25/05/2024", end_date: "25/05/2024", country: "Namibia")
# Holiday.create!(name: "Heroes' Day", start_date: "26/08/2024", end_date: "26/08/2024", country: "Namibia")
# Holiday.create!(name: "Human Rights Day", start_date: "10/12/2024", end_date: "10/12/2024", country: "Namibia")
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2025", end_date: "01/01/2025", country: "Namibia")
# Holiday.create!(name: "Independence Day", start_date: "21/03/2025", end_date: "21/03/2025", country: "Namibia")
# Holiday.create!(name: "Good Friday", start_date: "29/03/2025", end_date: "29/03/2025", country: "Namibia")
# Holiday.create!(name: "Workers' Day", start_date: "01/05/2025", end_date: "01/05/2025", country: "Namibia")
# Holiday.create!(name: "Cassinga Day", start_date: "04/05/2025", end_date: "04/05/2025", country: "Namibia")
# Holiday.create!(name: "Ascension Day", start_date: "09/05/2025", end_date: "09/05/2025", country: "Namibia")
# Holiday.create!(name: "Africa Day", start_date: "25/05/2025", end_date: "25/05/2025", country: "Namibia")
# Holiday.create!(name: "Heroes' Day", start_date: "26/08/2025", end_date: "26/08/2025", country: "Namibia")
# Holiday.create!(name: "Human Rights Day", start_date: "10/12/2025", end_date: "10/12/2025", country: "Namibia")
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2026", end_date: "01/01/2026", country: "Namibia")
# Holiday.create!(name: "Independence Day", start_date: "21/03/2026", end_date: "21/03/2026", country: "Namibia")
# Holiday.create!(name: "Good Friday", start_date: "29/03/2026", end_date: "29/03/2026", country: "Namibia")
# Holiday.create!(name: "Workers' Day", start_date: "01/05/2026", end_date: "01/05/2026", country: "Namibia")
# Holiday.create!(name: "Cassinga Day", start_date: "04/05/2026", end_date: "04/05/2026", country: "Namibia")
# Holiday.create!(name: "Ascension Day", start_date: "09/05/2026", end_date: "09/05/2026", country: "Namibia")
# Holiday.create!(name: "Africa Day", start_date: "25/05/2026", end_date: "25/05/2026", country: "Namibia")
# Holiday.create!(name: "Heroes' Day", start_date: "26/08/2026", end_date: "26/08/2026", country: "Namibia")
# Holiday.create!(name: "Human Rights Day", start_date: "10/12/2026", end_date: "10/12/2026", country: "Namibia")
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2027", end_date: "01/01/2027", country: "Namibia")
# Holiday.create!(name: "Independence Day", start_date: "21/03/2027", end_date: "21/03/2027", country: "Namibia")
# Holiday.create!(name: "Good Friday", start_date: "29/03/2027", end_date: "29/03/2027", country: "Namibia")
# Holiday.create!(name: "Workers' Day", start_date: "01/05/2027", end_date: "01/05/2027", country: "Namibia")
# Holiday.create!(name: "Cassinga Day", start_date: "04/05/2027", end_date: "04/05/2027", country: "Namibia")
# Holiday.create!(name: "Ascension Day", start_date: "09/05/2027", end_date: "09/05/2027", country: "Namibia")
# Holiday.create!(name: "Africa Day", start_date: "25/05/2027", end_date: "25/05/2027", country: "Namibia")
# Holiday.create!(name: "Heroes' Day", start_date: "26/08/2027", end_date: "26/08/2027", country: "Namibia")
# Holiday.create!(name: "Human Rights Day", start_date: "10/12/2027", end_date: "10/12/2027", country: "Namibia")
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2028", end_date: "01/01/2028", country: "Namibia")
# Holiday.create!(name: "Independence Day", start_date: "21/03/2028", end_date: "21/03/2028", country: "Namibia")
# Holiday.create!(name: "Good Friday", start_date: "29/03/2028", end_date: "29/03/2028", country: "Namibia")
# Holiday.create!(name: "Workers' Day", start_date: "01/05/2028", end_date: "01/05/2028", country: "Namibia")
# Holiday.create!(name: "Cassinga Day", start_date: "04/05/2028", end_date: "04/05/2028", country: "Namibia")
# Holiday.create!(name: "Ascension Day", start_date: "09/05/2028", end_date: "09/05/2028", country: "Namibia")
# Holiday.create!(name: "Africa Day", start_date: "25/05/2028", end_date: "25/05/2028", country: "Namibia")
# Holiday.create!(name: "Heroes' Day", start_date: "26/08/2028", end_date: "26/08/2028", country: "Namibia")
# Holiday.create!(name: "Human Rights Day", start_date: "10/12/2028", end_date: "10/12/2028", country: "Namibia")

# #South Africa
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2024", end_date: "01/01/2024", country: "South Africa")
# Holiday.create!(name: "Human Rights Day", start_date: "21/03/2024", end_date: "21/03/2024", country: "South Africa")
# Holiday.create!(name: "Good Friday", start_date: "29/03/2024", end_date: "29/03/2024", country: "South Africa")
# Holiday.create!(name: "Family Day", start_date: "01/04/2024", end_date: "01/04/2024", country: "South Africa")
# Holiday.create!(name: "Freedom Day", start_date: "27/04/2024", end_date: "27/04/2024", country: "South Africa")
# Holiday.create!(name: "Workers' Day", start_date: "01/05/2024", end_date: "01/05/2024", country: "South Africa")
# Holiday.create!(name: "Youth Day", start_date: "16/06/2024", end_date: "16/06/2024", country: "South Africa")
# Holiday.create!(name: "Youth Day Holiday", start_date: "17/06/2024", end_date: "17/06/2024", country: "South Africa")
# Holiday.create!(name: "National Women's Day", start_date: "9/8/2024", end_date: "9/8/2024", country: "South Africa")
# Holiday.create!(name: "Heritage Day", start_date: "24/09/2024", end_date: "24/09/2024", country: "South Africa")
# Holiday.create!(name: "Day of Reconciliation", start_date: "16/12/2024", end_date: "16/12/2024", country: "South Africa")
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2025", end_date: "01/01/2025", country: "South Africa")
# Holiday.create!(name: "Human Rights Day", start_date: "21/03/2025", end_date: "21/03/2025", country: "South Africa")
# Holiday.create!(name: "Good Friday", start_date: "29/03/2025", end_date: "29/03/2025", country: "South Africa")
# Holiday.create!(name: "Family Day", start_date: "01/04/2025", end_date: "01/04/2025", country: "South Africa")
# Holiday.create!(name: "Freedom Day", start_date: "27/04/2025", end_date: "27/04/2025", country: "South Africa")
# Holiday.create!(name: "Workers' Day", start_date: "01/05/2025", end_date: "01/05/2025", country: "South Africa")
# Holiday.create!(name: "Youth Day", start_date: "16/06/2025", end_date: "16/06/2025", country: "South Africa")
# Holiday.create!(name: "Youth Day Holiday", start_date: "17/06/2025", end_date: "17/06/2025", country: "South Africa")
# Holiday.create!(name: "National Women's Day", start_date: "9/8/2025", end_date: "9/8/2025", country: "South Africa")
# Holiday.create!(name: "Heritage Day", start_date: "24/09/2025", end_date: "24/09/2025", country: "South Africa")
# Holiday.create!(name: "Day of Reconciliation", start_date: "16/12/2025", end_date: "16/12/2025", country: "South Africa")
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2026", end_date: "01/01/2026", country: "South Africa")
# Holiday.create!(name: "Human Rights Day", start_date: "21/03/2026", end_date: "21/03/2026", country: "South Africa")
# Holiday.create!(name: "Good Friday", start_date: "29/03/2026", end_date: "29/03/2026", country: "South Africa")
# Holiday.create!(name: "Family Day", start_date: "01/04/2026", end_date: "01/04/2026", country: "South Africa")
# Holiday.create!(name: "Freedom Day", start_date: "27/04/2026", end_date: "27/04/2026", country: "South Africa")
# Holiday.create!(name: "Workers' Day", start_date: "01/05/2026", end_date: "01/05/2026", country: "South Africa")
# Holiday.create!(name: "Youth Day", start_date: "16/06/2026", end_date: "16/06/2026", country: "South Africa")
# Holiday.create!(name: "Youth Day Holiday", start_date: "17/06/2026", end_date: "17/06/2026", country: "South Africa")
# Holiday.create!(name: "National Women's Day", start_date: "9/8/2026", end_date: "9/8/2026", country: "South Africa")
# Holiday.create!(name: "Heritage Day", start_date: "24/09/2026", end_date: "24/09/2026", country: "South Africa")
# Holiday.create!(name: "Day of Reconciliation", start_date: "16/12/2026", end_date: "16/12/2026", country: "South Africa")
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2027", end_date: "01/01/2027", country: "South Africa")
# Holiday.create!(name: "Human Rights Day", start_date: "21/03/2027", end_date: "21/03/2027", country: "South Africa")
# Holiday.create!(name: "Good Friday", start_date: "29/03/2027", end_date: "29/03/2027", country: "South Africa")
# Holiday.create!(name: "Family Day", start_date: "01/04/2027", end_date: "01/04/2027", country: "South Africa")
# Holiday.create!(name: "Freedom Day", start_date: "27/04/2027", end_date: "27/04/2027", country: "South Africa")
# Holiday.create!(name: "Workers' Day", start_date: "01/05/2027", end_date: "01/05/2027", country: "South Africa")
# Holiday.create!(name: "Youth Day", start_date: "16/06/2027", end_date: "16/06/2027", country: "South Africa")
# Holiday.create!(name: "Youth Day Holiday", start_date: "17/06/2027", end_date: "17/06/2027", country: "South Africa")
# Holiday.create!(name: "National Women's Day", start_date: "9/8/2027", end_date: "9/8/2027", country: "South Africa")
# Holiday.create!(name: "Heritage Day", start_date: "24/09/2027", end_date: "24/09/2027", country: "South Africa")
# Holiday.create!(name: "Day of Reconciliation", start_date: "16/12/2027", end_date: "16/12/2027", country: "South Africa")
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2028", end_date: "01/01/2028", country: "South Africa")
# Holiday.create!(name: "Human Rights Day", start_date: "21/03/2028", end_date: "21/03/2028", country: "South Africa")
# Holiday.create!(name: "Good Friday", start_date: "29/03/2028", end_date: "29/03/2028", country: "South Africa")
# Holiday.create!(name: "Family Day", start_date: "01/04/2028", end_date: "01/04/2028", country: "South Africa")
# Holiday.create!(name: "Freedom Day", start_date: "27/04/2028", end_date: "27/04/2028", country: "South Africa")
# Holiday.create!(name: "Workers' Day", start_date: "01/05/2028", end_date: "01/05/2028", country: "South Africa")
# Holiday.create!(name: "Youth Day", start_date: "16/06/2028", end_date: "16/06/2028", country: "South Africa")
# Holiday.create!(name: "Youth Day Holiday", start_date: "17/06/2028", end_date: "17/06/2028", country: "South Africa")
# Holiday.create!(name: "National Women's Day", start_date: "9/8/2028", end_date: "9/8/2028", country: "South Africa")
# Holiday.create!(name: "Heritage Day", start_date: "24/09/2028", end_date: "24/09/2028", country: "South Africa")
# Holiday.create!(name: "Day of Reconciliation", start_date: "16/12/2028", end_date: "16/12/2028", country: "South Africa")

# #Spain
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2024", end_date: "01/01/2024", country: "Spain")
# Holiday.create!(name: "Epiphany of the Lord", start_date: "06/01/2024", end_date: "06/01/2024", country: "Spain")
# Holiday.create!(name: "Maundy Thursday", start_date: "28/03/2024", end_date: "28/03/2024", country: "Spain")
# Holiday.create!(name: "Good Friday", start_date: "29/03/2024", end_date: "29/03/2024", country: "Spain")
# Holiday.create!(name: "Labour Day", start_date: "01/05/2024", end_date: "01/05/2024", country: "Spain")
# Holiday.create!(name: "Assumption of the Virgin", start_date: "15/08/2024", end_date: "15/08/2024", country: "Spain")
# Holiday.create!(name: "National Day of Spain", start_date: "12/10/2024", end_date: "12/10/2024", country: "Spain")
# Holiday.create!(name: "All Saints", start_date: "01/11/2024", end_date: "01/11/2024", country: "Spain")
# Holiday.create!(name: "Spanish Constitution Day", start_date: "06/12/2024", end_date: "06/12/2024", country: "Spain")
# Holiday.create!(name: "Observation Day of Immaculate Conception", start_date: "09/12/2024", end_date: "09/12/2024", country: "Spain")
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2025", end_date: "01/01/2025", country: "Spain")
# Holiday.create!(name: "Epiphany of the Lord", start_date: "06/01/2025", end_date: "06/01/2025", country: "Spain")
# Holiday.create!(name: "Maundy Thursday", start_date: "17/04/2025", end_date: "17/04/2025", country: "Spain")
# Holiday.create!(name: "Good Friday", start_date: "18/04/2025", end_date: "18/04/2025", country: "Spain")
# Holiday.create!(name: "Labour Day", start_date: "01/05/2025", end_date: "01/05/2025", country: "Spain")
# Holiday.create!(name: "Assumption of the Virgin", start_date: "15/08/2025", end_date: "15/08/2025", country: "Spain")
# Holiday.create!(name: "National Day of Spain", start_date: "12/10/2025", end_date: "12/10/2025", country: "Spain")
# Holiday.create!(name: "All Saints", start_date: "01/11/2025", end_date: "01/11/2025", country: "Spain")
# Holiday.create!(name: "Spanish Constitution Day", start_date: "06/12/2025", end_date: "06/12/2025", country: "Spain")
# Holiday.create!(name: "Observation Day of Immaculate Conception", start_date: "09/12/2025", end_date: "09/12/2025", country: "Spain")
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2026", end_date: "01/01/2026", country: "Spain")
# Holiday.create!(name: "Epiphany of the Lord", start_date: "06/01/2026", end_date: "06/01/2026", country: "Spain")
# Holiday.create!(name: "Maundy Thursday", start_date: "02/04/2026", end_date: "02/04/2026", country: "Spain")
# Holiday.create!(name: "Good Friday", start_date: "03/04/2026", end_date: "03/04/2026", country: "Spain")
# Holiday.create!(name: "Labour Day", start_date: "01/05/2026", end_date: "01/05/2026", country: "Spain")
# Holiday.create!(name: "Assumption of the Virgin", start_date: "15/08/2026", end_date: "15/08/2026", country: "Spain")
# Holiday.create!(name: "National Day of Spain", start_date: "12/10/2026", end_date: "12/10/2026", country: "Spain")
# Holiday.create!(name: "All Saints", start_date: "01/11/2026", end_date: "01/11/2026", country: "Spain")
# Holiday.create!(name: "Spanish Constitution Day", start_date: "06/12/2026", end_date: "06/12/2026", country: "Spain")
# Holiday.create!(name: "Observation Day of Immaculate Conception", start_date: "09/12/2026", end_date: "09/12/2026", country: "Spain")
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2027", end_date: "01/01/2027", country: "Spain")
# Holiday.create!(name: "Epiphany of the Lord", start_date: "06/01/2027", end_date: "06/01/2027", country: "Spain")
# Holiday.create!(name: "Maundy Thursday", start_date: "25/03/2027", end_date: "25/03/2027", country: "Spain")
# Holiday.create!(name: "Good Friday", start_date: "26/03/2027", end_date: "26/03/2027", country: "Spain")
# Holiday.create!(name: "Labour Day", start_date: "01/05/2027", end_date: "01/05/2027", country: "Spain")
# Holiday.create!(name: "Assumption of the Virgin", start_date: "15/08/2027", end_date: "15/08/2027", country: "Spain")
# Holiday.create!(name: "National Day of Spain", start_date: "12/10/2027", end_date: "12/10/2027", country: "Spain")
# Holiday.create!(name: "All Saints", start_date: "01/11/2027", end_date: "01/11/2027", country: "Spain")
# Holiday.create!(name: "Spanish Constitution Day", start_date: "06/12/2027", end_date: "06/12/2027", country: "Spain")
# Holiday.create!(name: "Observation Day of Immaculate Conception", start_date: "09/12/2027", end_date: "09/12/2027", country: "Spain")
# Holiday.create!(name: "New Year's Day", start_date: "01/01/2028", end_date: "01/01/2028", country: "Spain")
# Holiday.create!(name: "Epiphany of the Lord", start_date: "06/01/2028", end_date: "06/01/2028", country: "Spain")
# Holiday.create!(name: "Maundy Thursday", start_date: "28/03/2028", end_date: "28/03/2028", country: "Spain")
# Holiday.create!(name: "Good Friday", start_date: "29/03/2028", end_date: "29/03/2028", country: "Spain")
# Holiday.create!(name: "Labour Day", start_date: "01/05/2028", end_date: "01/05/2028", country: "Spain")
# Holiday.create!(name: "Assumption of the Virgin", start_date: "15/08/2028", end_date: "15/08/2028", country: "Spain")
# Holiday.create!(name: "National Day of Spain", start_date: "12/10/2028", end_date: "12/10/2028", country: "Spain")
# Holiday.create!(name: "All Saints", start_date: "01/11/2028", end_date: "01/11/2028", country: "Spain")
# Holiday.create!(name: "Spanish Constitution Day", start_date: "06/12/2028", end_date: "06/12/2028", country: "Spain")
# Holiday.create!(name: "Observation Day of Immaculate Conception", start_date: "09/12/2028", end_date: "09/12/2028", country: "Spain")

end
