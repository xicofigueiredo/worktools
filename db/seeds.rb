# db/seeds.rb

# Define the subjects for each category along with exam dates
# db/seeds.rb


math_a_level = Subject.create!(
  name: "Mathematics A Level",
  category: :al,
)

  math_a_level.topics.create!(name: "Introduction to the Course", time: 1)
  math_a_level.topics.create!(name: "Pre-course", time: 1)
  math_a_level.topics.create!(name: "Topic 1.1 Introduction to Methods of proof", time: 4, unit: "Unit 1: Proof")
  math_a_level.topics.create!(name: "Topic 1.2 - Proof by Contradiction", time: 3, unit: "Unit 1: Proof")
  math_a_level.topics.create!(name: "Topic 2.1 Algebraic Expressions, Indices and Surds", time: 4, unit: "Unit 2: Algebra and Functions")
  math_a_level.topics.create!(name: "Topic 2.2 Quadratics", time: 5, unit: "Unit 2: Algebra and Functions")
  math_a_level.topics.create!(name: "Topic 2.3 -  Simultaneous Equations", time: 4, unit: "Unit 2: Algebra and Functions")
  math_a_level.topics.create!(name: "Topic 2.4 - Inequalities", time: 6, unit: "Unit 2: Algebra and Functions")
  math_a_level.topics.create!(name: "Topic 2.5 - Polynomial and Reciprocal Functions", time: 5, unit: "Unit 2: Algebra and Functions")
  math_a_level.topics.create!(name: "Topic 2.6 - Transformations and Symmetries", time: 6, unit: "Unit 2: Algebra and Functions")
  math_a_level.topics.create!(name: "Topic 2.7 - Algebraic Division", time: 4, unit: "Unit 2: Algebra and Functions")
  math_a_level.topics.create!(name: "End of Unit Assessments", time: 3, unit: "Unit 2: Algebra and Functions", has_grade: true)
  math_a_level.topics.create!(name: "Topic 2.8 - Algebraic Fraction Manipulation", time: 2, unit: "Unit 2: Algebra and Functions")
  math_a_level.topics.create!(name: "Topic 2.9 - Partial Fractions", time: 4, unit: "Unit 2: Algebra and Functions")
  math_a_level.topics.create!(name: "Topic 2.10 - Composite and Inverse Functions", time: 4, unit: "Unit 2: Algebra and Functions")
  math_a_level.topics.create!(name: "Topic 2.11 - Modulus Function", time: 5, unit: "Unit 2: Algebra and Functions")
  math_a_level.topics.create!(name: "Topic 2.12 - Composite Transformations", time: 3, unit: "Unit 2: Algebra and Functions")
  math_a_level.topics.create!(name: "End of Unit Assessments", time: 3, unit: "Unit 2: Algebra and Functions", has_grade: true)
  math_a_level.topics.create!(name: "Topic 3.1 - Coordinate Geometry of Straigh Lines", time: 6, unit: "Unit 3: Coordinate Geometry")
  math_a_level.topics.create!(name: "Topic 3.2 - Coordinate Geometry of Circles", time: 8, unit: "Unit 3: Coordinate Geometry")
  math_a_level.topics.create!(name: "Topic 3.3 - Parametric Equations", time: 3, unit: "Unit 3: Coordinate Geometry")
  math_a_level.topics.create!(name: "End of Unit Assessments", time: 1, unit: "Unit 3: Coordinate Geometry", has_grade: true)
  math_a_level.topics.create!(name: "Topic 4.1. Arithmetic Sequences and Series", time: 2, unit: "Unit 4: Sequences, Series and Binomial Expansion")
  math_a_level.topics.create!(name: "Topic 4.2.  Geometric Sequences and Series", time: 3, unit: "Unit 4: Sequences, Series and Binomial Expansion")
  math_a_level.topics.create!(name: "Topic 4.3 - General Sequences, Series and Notation", time: 5, unit: "Unit 4: Sequences, Series and Binomial Expansion")
  math_a_level.topics.create!(name: "Topic 4.4 - Binomial Expansion for Positive Integer Exponents", time: 7, unit: "Unit 4: Sequences, Series and Binomial Expansion")
  math_a_level.topics.create!(name: "End of Unit Assessments", time: 3, unit: "Unit 4: Sequences, Series and Binomial Expansion", has_grade: true)
  math_a_level.topics.create!(name: "Topic 4.5 - Binomial Expansion for Rational Powers", time: 7, unit: "Unit 4: Sequences, Series and Binomial Expansion")
  math_a_level.topics.create!(name: "End of Unit Assessments", time: 3, unit: "Unit 4: Sequences, Series and Binomial Expansion")
  math_a_level.topics.create!(name: "Topic 5.1. Trigonometry in Triangles", time: 6, unit: "Unit 5: Trigonomentry and Trigonometric Functions", has_grade: true)
  math_a_level.topics.create!(name: "Topic 5.2. Trigonometry in Circles", time: 5, unit: "Unit 5: Trigonomentry and Trigonometric Functions")
  math_a_level.topics.create!(name: "Topic 5.3 - Trigonometric Functions", time: 2, unit: "Unit 5: Trigonomentry and Trigonometric Functions")
  math_a_level.topics.create!(name: "Topic 5.4 - Trigonometric Identities", time: 5, unit: "Unit 5: Trigonomentry and Trigonometric Functions")
  math_a_level.topics.create!(name: "Topic 5.5 - Trigonometric Equations", time: 5, unit: "Unit 5: Trigonomentry and Trigonometric Functions")
  math_a_level.topics.create!(name: "End of Unit Assessments", time: 1, unit: "Unit 5: Trigonomentry and Trigonometric Functions", has_grade: true)
  math_a_level.topics.create!(name: "Topic 5.6 - Reciprocal Trigonometric Functions and Identities", time: 2, unit: "Unit 5: Trigonomentry and Trigonometric Functions")
  math_a_level.topics.create!(name: "Topic 5.7 - Inverse Trigonometric Functions", time: 3, unit: "Unit 5: Trigonomentry and Trigonometric Functions")
  math_a_level.topics.create!(name: "Topic 5.8 - Compound, Double and Half-Angle Formulae", time: 6, unit: "Unit 5: Trigonomentry and Trigonometric Functions")
  math_a_level.topics.create!(name: "Topic 5.9 - Harmonic Forms", time: 3, unit: "Unit 5: Trigonomentry and Trigonometric Functions")
  math_a_level.topics.create!(name: "End of Unit Assessments", time: 2, unit: "Unit 5: Trigonomentry and Trigonometric Functions", has_grade: true)
  math_a_level.topics.create!(name: "Topic 6.1 - Exponential and Logarithmic Functions", time: 2, unit: "Unit 6: Exponentials and Logarithms")
  math_a_level.topics.create!(name: "Topic 6.2 - Manipulating Exponential and Logarithmic Expressions", time: 6, unit: "Unit 6: Exponentials and Logarithms")
  math_a_level.topics.create!(name: "End of Unit Assessments", time: 3, unit: "Unit 6: Exponentials and Logarithms", has_grade: true)
  math_a_level.topics.create!(name: "Topic 6.3 - Natural Exponential and Logarithmic Functions", time: 2, unit: "Unit 6: Exponentials and Logarithms")
  math_a_level.topics.create!(name: "Topic 6.4 - Modelling with Exponential and Logarithmic Functions", time: 8, unit: "Unit 6: Exponentials and Logarithms")
  math_a_level.topics.create!(name: "End of Unit Assessments", time: 3, unit: "Unit 6: Exponentials and Logarithms", has_grade: true)
  math_a_level.topics.create!(name: "Topic 7.1 - Introduction to Differentiation: Powers", time: 11, unit: "Unit 7: Differentiation")
  math_a_level.topics.create!(name: "Topic 7.2 - Stationary Points and Function Behaviour", time: 4, unit: "Unit 7: Differentiation")
  math_a_level.topics.create!(name: "End of Unit Assessments", time: 1, unit: "Unit 7: Differentiation", has_grade: true)
  math_a_level.topics.create!(name: "Topic 7.3 - Differentiating Exponentials, Logarithms and Trigonometric Functions", time: 5, unit: "Unit 7: Differentiation")
  math_a_level.topics.create!(name: "Topic 7.4 - Differentiation Techniques: Product Rule, Quotient Rule and Chain Rule", time: 7, unit: "Unit 7: Differentiation")
  math_a_level.topics.create!(name: "Topic 7.5 - Differentiating Implicit and Parametric Functions", time: 5, unit: "Unit 7: Differentiation")
  math_a_level.topics.create!(name: "Topic 7.6 - Connected Rates of Change", time: 3, unit: "Unit 7: Differentiation")
  math_a_level.topics.create!(name: "End of Unit Assessments", time: 1, unit: "Unit 7: Differentiation", has_grade: true)
  math_a_level.topics.create!(name: "Topic 8.1 - Indefinite Integration", time: 6, unit: "Unit 8: Integration")
  math_a_level.topics.create!(name: "Topic 8.2 - Definite Integration and Area under a Curve", time: 5, unit: "Unit 8: Integration")
  math_a_level.topics.create!(name: "Topic 8.3 - Numerical Integration using the Trapezium Rule", time: 2, unit: "Unit 8: Integration")
  math_a_level.topics.create!(name: "End of Unit Assessments", time: 2, unit: "Unit 8: Integration", has_grade: true)
  math_a_level.topics.create!(name: "Topic 8.4 - Integrating Standard Functions", time: 4, unit: "Unit 8: Integration")
  math_a_level.topics.create!(name: "Topic 8.5 - Integration by Recognition of Known Derivatives and using Trigonometric Identities", time: 5, unit: "Unit 8: Integration")
  math_a_level.topics.create!(name: "Topic 8.6 - Volumes of Revolution", time: 5, unit: "Unit 8: Integration")
  math_a_level.topics.create!(name: "Topic 8.7 - Integration Techniques: Integration by Substitution and Integration by Parts", time: 7, unit: "Unit 8: Integration")
  math_a_level.topics.create!(name: "Topic 8.8 - Integration of Rational Functions using Partial Fractions", time: 3, unit: "Unit 8: Integration")
  math_a_level.topics.create!(name: "Topic 8.9 - Differential Equations", time: 2, unit: "Unit 8: Integration")
  math_a_level.topics.create!(name: "Topic 8.10 - Modelling with Differential Equations", time: 2, unit: "Unit 8: Integration")
  math_a_level.topics.create!(name: "End of Unit Assessments", time: 3, unit: "Unit 8: Integration", has_grade: true)
  math_a_level.topics.create!(name: "Topic 9.1 - Locating Roots", time: 1, unit: "Unit 9: Numerical Methods")
  math_a_level.topics.create!(name: "Topic 9.2 - Iterative Methods for Solving Equations", time: 4, unit: "Unit 9: Numerical Methods")
  math_a_level.topics.create!(name: "End of Unit Assessments", time: 1, unit: "Unit 9: Numerical Methods", has_grade: true)
  math_a_level.topics.create!(name: "Topic 10.1 - Vector Representations and Operations", time: 5, unit: "Unit 10: Vectors")
  math_a_level.topics.create!(name: "Topic 10.2 - Position Vectors and Geometrical Problems", time: 3, unit: "Unit 10: Vectors")
  math_a_level.topics.create!(name: "Topic 10.3 - Vector Equation of the Line", time: 5, unit: "Unit 10: Vectors")
  math_a_level.topics.create!(name: "Topic 10.4 - Scalar Product", time: 5, unit: "Unit 10: Vectors")
  math_a_level.topics.create!(name: "End of Unit Assessments", time: 3, unit: "Unit 10: Vectors", has_grade: true)
  math_a_level.topics.create!(name: "Pure Mathematics MOCK - Paper 1,2,3,4", time: 7, milestone: true, has_grade: true)
  math_a_level.topics.create!(name: "Topic 11.1 - Measures of Location and Variation", time: 5, unit: "Unit 11: Representing and Summarising Data")
  math_a_level.topics.create!(name: "Topic 11.2 - Representing and Comparing Data using Diagrams", time: 8, unit: "Unit 11: Representing and Summarising Data")
  math_a_level.topics.create!(name: "End of Unit Assessments", time: 1, unit: "Unit 11: Statistics", has_grade: true)
  math_a_level.topics.create!(name: "Topic 12.1 - Events, Set Notation and Probability Calculations", time: 7, unit: "Unit 12: Probability")
  math_a_level.topics.create!(name: "Topic 12.2 - Conditional Probability", time: 3, unit: "Unit 12: Probability")
  math_a_level.topics.create!(name: "End of Unit Assessments", time: 1, unit: "Unit 12: Probability")
  math_a_level.topics.create!(name: "Topic 13.1 - Scatter Diagrams and Least Squares Linear Regression", time: 9, unit: "Unit 13:  Correlation and Regression")
  math_a_level.topics.create!(name: "Topic 13.2 - Product Moment Correlation Coeficient (PMCC)", time: 7, unit: "Unit 13:  Correlation and Regression")
  math_a_level.topics.create!(name: "End of Unit Assessments", time: 1, unit: "Unit 13:  Correlation and Regression", has_grade: true)
  math_a_level.topics.create!(name: "Topic 14.1. Discrete Random Variables and Distributions", time: 13, unit: "Unit 14: Random Variables and Distributions")
  math_a_level.topics.create!(name: "Topic 14.2. Continuous Random Variables and Normal Distribution", time: 8, unit: "Unit 14: Random Variables and Distributions")
  math_a_level.topics.create!(name: "End of Unit Assessments", time: 1, unit: "Unit 14: Random Variables and Distributions", has_grade: true)
  math_a_level.topics.create!(name: "Warm up mock", time: 3, milestone: true, has_grade: true)
  math_a_level.topics.create!(name: "Statistics MOCK", time: 2, milestone: true, has_grade: true)
  math_a_level.topics.create!(name: "Topic 16.1 - Quantities and Units in Mechanics Models", time: 2, unit: "Unit 16: Mathematical Models in Mechanics")
  math_a_level.topics.create!(name: "Topic 16.2 - Representing Physical Quantities in Mechanics Models", time: 13, unit: "Unit 16: Mathematical Models in Mechanics")
  math_a_level.topics.create!(name: "MA: End of Unit Assessment 16", time: 1, unit: "Unit 16: Mathematical Models in Mechanics", has_grade: true)
  math_a_level.topics.create!(name: "Topic 17.1 - Constant Acceleration Formulae", time: 4, unit: "Unit 17: Kinematics of Particles Moving in a Straight Line")
  math_a_level.topics.create!(name: "Topic 17.2 - Representing and Interpreting Physical Quantities as Graphs", time: 6, unit: "Unit 17: Kinematics of Particles Moving in a Straight Line")
  math_a_level.topics.create!(name: "Topic 17.3 - Vertical Motion Under Gravity", time: 2, unit: "Unit 17: Kinematics of Particles Moving in a Straight Line")
  math_a_level.topics.create!(name: "MA: End of unit assessment 17", time: 1, unit: "Unit 17: Kinematics of Particles Moving in a Straight Line", has_grade: true)
  math_a_level.topics.create!(name: "Topic 18.1 - Representing and Calculating Resultant Forces", time: 3, unit: "Unit 18: Dynamics of Particles Moving in a Straight Line")
  math_a_level.topics.create!(name: "Topic 18.2 - Newtons Second Law", time: 4, unit: "Unit 18: Dynamics of Particles Moving in a Straight Line")
  math_a_level.topics.create!(name: "Topic 18.3 - Frictional Forces", time: 4, unit: "Unit 18: Dynamics of Particles Moving in a Straight Line")
  math_a_level.topics.create!(name: "Topic 18.4 - Connected Particles and Smooth Pulleys", time: 4, unit: "Unit 18: Dynamics of Particles Moving in a Straight Line")
  math_a_level.topics.create!(name: "Topic 18.5 - Momentum, Impulse and Collisions in 1D", time: 8, unit: "Unit 18: Dynamics of Particles Moving in a Straight Line")
  math_a_level.topics.create!(name: "End of Unit Assement 18", time: 1, unit: "Unit 18: Dynamics of Particles Moving in a Straight Line", has_grade: true)
  math_a_level.topics.create!(name: "Topic 19.1 - Static Equilibrium", time: 4, unit: "Unit 19: Statics")
  math_a_level.topics.create!(name: "Topic 20.1 - Moment of a Force and Rotational Equilibrium", time: 7, unit: "Unit 20: Rotational Effects of Forces")
  math_a_level.topics.create!(name: "End of Unit Assessment 20", time: 1, unit: "Unit 20: Rotational Effects of Forces", has_grade: true)
  math_a_level.topics.create!(name: "Course Revision Assessment & Exam Preparation", time: 5, milestone: true, has_grade: true)
  math_a_level.topics.create!(name: "Warm up mock", time: 3, milestone: true, has_grade: true)
  math_a_level.topics.create!(name: "Mechanics MOCK", time: 1, milestone: true, has_grade: true)


  chemistry_a_level = Subject.create!(
  name: "Chemistry A Level",
  category: :al,
  )

chemistry_a_level.topics.create!(name: "Topic 1: Fundamental Skills", time: 4, unit: "Unit 0: Introduction to A-Level Chemistry")
chemistry_a_level.topics.create!(name: "Topic 2: Bridging the Gap", time: 4, unit: "Unit 0: Introduction to A-Level Chemistry")
chemistry_a_level.topics.create!(name: "Topic 1: Moles and Equations", time: 10, unit: "Unit 1: Structure and Bonding")
chemistry_a_level.topics.create!(name: "Topic 2: Atomic Structure", time: 5, unit: "Unit 1: Structure and Bonding")
chemistry_a_level.topics.create!(name: "Topic 3: Electronic Structure", time: 12, unit: "Unit 1: Structure and Bonding")
chemistry_a_level.topics.create!(name: "Topic 4: Periodic Table", time: 7, unit: "Unit 1: Structure and Bonding")
chemistry_a_level.topics.create!(name: "Topic 5: States of Matter", time: 3, unit: "Unit 1: Structure and Bonding")
chemistry_a_level.topics.create!(name: "Topic 6: Chemical Bonding", time: 15, unit: "Unit 1: Structure and Bonding")
chemistry_a_level.topics.create!(name: "Topic 1: Introductory Organic Chemistry", time: 15, unit: "Unit 2: Introduction to Organic Chemistry")
chemistry_a_level.topics.create!(name: "Topic 2: Alkanes", time: 10, unit: "Unit 2: Introduction to Organic Chemistry")
chemistry_a_level.topics.create!(name: "Topic 3: Alkenes", time: 10, unit: "Unit 2: Introduction to Organic Chemistry")
chemistry_a_level.topics.create!(name: "Warm-up Mock I", time: 2, milestone: true, has_grade: true)
chemistry_a_level.topics.create!(name: "Topic 1: Intermolecular Forces", time: 15, unit: "Unit 3: Energetics and Group Chemistry")
chemistry_a_level.topics.create!(name: "Topic 2: Energetics", time: 15, unit: "Unit 3: Energetics and Group Chemistry")
chemistry_a_level.topics.create!(name: "Topic 3: Introduction to Kinetics and Equilibria", time: 15, unit: "Unit 3: Energetics and Group Chemistry")
chemistry_a_level.topics.create!(name: "Topic 4: Redox Chemistry", time: 5, unit: "Unit 3: Energetics and Group Chemistry")
chemistry_a_level.topics.create!(name: "Topic 5: Group Chemistry", time: 12, unit: "Unit 3: Energetics and Group Chemistry")
chemistry_a_level.topics.create!(name: "Topic 1: Halogenoalkanes", time: 7, unit: "Unit 4: More Organic Chemistry")
chemistry_a_level.topics.create!(name: "Topic 2: Alcohols", time: 7, unit: "Unit 4: More Organic Chemistry")
chemistry_a_level.topics.create!(name: "Topic 3: Mass Spectra and IR", time: 7, unit: "Unit 4: More Organic Chemistry")
chemistry_a_level.topics.create!(name: "Warm-up Mock II", time: 2, milestone: true, has_grade: true)
chemistry_a_level.topics.create!(name: "Topic 1: Review of practical knowledge and understanding", time: 3, unit: "Unit 5: Practical Skills")
chemistry_a_level.topics.create!(name: "Topic 2: Colours", time: 3, unit: "Unit 5: Practical Skills")
chemistry_a_level.topics.create!(name: "Mock 50%", time: 3, milestone: true, has_grade: true)
chemistry_a_level.topics.create!(name: "Topic 1: Kinetics", time: 12, unit: "Unit 6: Rates and Equilibria")
chemistry_a_level.topics.create!(name: "Topic 2: Entropy and Energetics", time: 12, unit: "Unit 6: Rates and Equilibria")
chemistry_a_level.topics.create!(name: "Topic 3: Chemical Equilibria", time: 12, unit: "Unit 6: Rates and Equilibria")
chemistry_a_level.topics.create!(name: "Topic 4: Acid-base Equilibria", time: 12, unit: "Unit 6: Rates and Equilibria")
chemistry_a_level.topics.create!(name: "Topic 1: Chirality", time: 7, unit: "Unit 7: Further Organic Chemistry")
chemistry_a_level.topics.create!(name: "Topic 2: Carbonyl Group", time: 12, unit: "Unit 7: Further Organic Chemistry")
chemistry_a_level.topics.create!(name: "Topic 3: Spectroscopy and Chromatography", time: 7, unit: "Unit 7: Further Organic Chemistry")
chemistry_a_level.topics.create!(name: "Warm-up Mock IV", time: 2, milestone: true, has_grade: true)
chemistry_a_level.topics.create!(name: "Topic 1: Redox Equilibria", time: 7, unit: "Unit 8: Transition Metals")
chemistry_a_level.topics.create!(name: "Topic 2: Transition Metals", time: 14, unit: "Unit 8: Transition Metals")
chemistry_a_level.topics.create!(name: "Topic 1: Arenes", time: 7, unit: "Unit 9: Organic Nitrogen Chemistry")
chemistry_a_level.topics.create!(name: "Topic 2: Organic Nitrogen Compounds", time: 9, unit: "Unit 9: Organic Nitrogen Chemistry")
chemistry_a_level.topics.create!(name: "Topic 3: Organic Synthesis", time: 2, unit: "Unit 9: Organic Nitrogen Chemistry")
chemistry_a_level.topics.create!(name: "Warm-up Mock V", time: 2, milestone: true, has_grade: true)
chemistry_a_level.topics.create!(name: "Topic 1: Lab Techniques", time: 8, unit: "Unit 10: Exam Preparation")
chemistry_a_level.topics.create!(name: "Topic 2: Chemical Analysis", time: 8, unit: "Unit 10: Exam Preparation")
chemistry_a_level.topics.create!(name: "Mock 100%", time: 3, milestone: true, has_grade: true)

physics_a_level = Subject.create!(
  name: "Physics A Level",
  category: :al,
  )

  physics_a_level.topics.create!(name: "Practical Skills in Physics: Part 1", time: 4, unit: "Unit 0: Introduction to A-Level Physics")
  physics_a_level.topics.create!(name: "Unit 1: Topic 1.1: Kinematics in 1 Dimension", time: 8, unit: "Unit 1: Mechanics")
  physics_a_level.topics.create!(name: "Topic 1.2: Kinematics in 2 Dimensions", time: 11, unit: "Unit 1: Mechanics")
  physics_a_level.topics.create!(name: "Topic 1.3: Single Body Dynamics", time: 8, unit: "Unit 1: Mechanics")
  physics_a_level.topics.create!(name: "Topic 1.4: Multiple Body Dynamics", time: 10, unit: "Unit 1: Mechanics")
  physics_a_level.topics.create!(name: "Topic 1.5: Rotational Effect of a Force", time: 6, unit: "Unit 1: Mechanics")
  physics_a_level.topics.create!(name: "Topic 1.6: Mechanical Energy and Work", time: 13, unit: "Unit 1: Mechanics")
  physics_a_level.topics.create!(name: "Unit 2: Topic 2.1: Material vs Object Properties", time: 4, unit: "Unit 2: Materials")
  physics_a_level.topics.create!(name: "Topic 2.2: Forces in Fluids: Viscous Drag and Upthrust", time: 8, unit: "Unit 2: Materials")
  physics_a_level.topics.create!(name: "Topic 2.3: Forces and Deformation", time: 6, unit: "Unit 2: Materials")
  physics_a_level.topics.create!(name: "Topic 2.4: Stress, Strain and the Young Modulus", time: 6, unit: "Unit 2: Materials")
  physics_a_level.topics.create!(name: "Topic 2.5: Energy Considerations in Deformation", time: 9, unit: "Unit 2: Materials")
  physics_a_level.topics.create!(name: "Unit 3: Topic 3.1: Wave Types and Properties", time: 8, unit: "Unit 3: Waves")
  physics_a_level.topics.create!(name: "Topic 3.2: How Waves Interact With Other Waves", time: 14, unit: "Unit 3: Waves")
  physics_a_level.topics.create!(name: "Topic 3.3: How Waves Interact With Matter", time: 15, unit: "Unit 3: Waves")
  physics_a_level.topics.create!(name: "Unit 4: Topic 4.1: Wave Particle Duality", time: 6, unit: "Unit 4: Quantum Physics")
  physics_a_level.topics.create!(name: "Topic 4.2: Energy of a Photon and Photoelectric Effect", time: 6, unit: "Unit 4: Quantum Physics")
  physics_a_level.topics.create!(name: "Topic 4.3: Atomic Electron Energies and Atomic Spectra", time: 9, unit: "Unit 4: Quantum Physics")
  physics_a_level.topics.create!(name: "Unit 5: Topic 5.1: Macroscopic Electrical Quantities", time: 8, unit: "Unit 5: Electricity")
  physics_a_level.topics.create!(name: "Topic 5.2: Microscopic Eelectrical Quantities", time: 8, unit: "Unit 5: Electricity")
  physics_a_level.topics.create!(name: "Topic 5.3: Circuit Topologies", time: 10, unit: "Unit 5: Electricity")
  physics_a_level.topics.create!(name: "Topic 5.4: Internal Resistance and EMF", time: 6, unit: "Unit 5: Electricity")
  physics_a_level.topics.create!(name: "Topic 5.5: Variable Resistances", time: 9, unit: "Unit 5: Electricity")
  physics_a_level.topics.create!(name: "Unit 6: Topic 6.1: Charge, Electric Field, Electric Force", time: 8, unit: "Unit 6: Fields")
  physics_a_level.topics.create!(name: "Topic 6.2: Role of Electric Fields in Circuits", time: 6, unit: "Unit 6: Fields")
  physics_a_level.topics.create!(name: "Topic 6.3: Magnetic Field and Magnetic Force", time: 6, unit: "Unit 6: Fields")
  physics_a_level.topics.create!(name: "Topic 6.4: Electromagnetic Induction", time: 11, unit: "Unit 6: Fields")
  physics_a_level.topics.create!(name: "Mock 50% Warm Up", time: 2, milestone: true, has_grade: true)
  physics_a_level.topics.create!(name: "Mock 50%", time: 3, milestone: true, has_grade: true)
  physics_a_level.topics.create!(name: "Practical Skills in Physics: Part 2", time: 4, unit: "Unit 0: Introduction to A-Level Physics")
  physics_a_level.topics.create!(name: "Unit 7: Topic 7.1: Nuclear Models of the Atom and Where We are Now", time: 4, unit: "Unit 7: Nuclear Physics")
  physics_a_level.topics.create!(name: "Topic 7.2: Exploring the Structure of Matter", time: 6, unit: "Unit 7: Nuclear Physics")
  physics_a_level.topics.create!(name: "Topic 7.3: Standard Model: Particle Interactions", time: 11, unit: "Unit 7: Nuclear Physics")
  physics_a_level.topics.create!(name: "Unit 8: Topic 8.1: Temperature and Internal Energy", time: 6, unit: "Unit 8: Thermal Physics")
  physics_a_level.topics.create!(name: "Topic 8.2: Heat Transfer", time: 11, unit: "Unit 8: Thermal Physics")
  physics_a_level.topics.create!(name: "Topic 8.3: Kinetic Theory and Ideal Gases", time: 11, unit: "Unit 8: Thermal Physics")
  physics_a_level.topics.create!(name: "Unit 9: Topic 9.1: Types of Nuclear Radiation", time: 6, unit: "Unit 9: Nuclear Physics")
  physics_a_level.topics.create!(name: "Topic 9.2: Radioactive Decay", time: 8, unit: "Unit 9: Nuclear Physics")
  physics_a_level.topics.create!(name: "Topic 9.3: Nuclear Binding Energy", time: 11, unit: "Unit 9: Nuclear Physics")
  physics_a_level.topics.create!(name: "Unit 10: Topic 10.1: Newtons Law of Universal Gravitation", time: 8, unit: "Unit 10: Astrophysics")
  physics_a_level.topics.create!(name: "Topic 10.2: Orbital Motion", time: 11, unit: "Unit 10: Astrophysics")
  physics_a_level.topics.create!(name: "Unit 11: Topic 11.1: Black Body Radiation", time: 6, unit: "Unit 11: Cosmology")
  physics_a_level.topics.create!(name: "Topic 11.2: Stellar Classification", time: 8, unit: "Unit 11: Cosmology")
  physics_a_level.topics.create!(name: "Topic 11.3: Stellar Distances", time: 4, unit: "Unit 11: Cosmology")
  physics_a_level.topics.create!(name: "Topic 11.4: Age of the Universe", time: 13, unit: "Unit 11: Cosmology")
  physics_a_level.topics.create!(name: "Unit 12: Topic 12.1: Colision Dynamics", time: 8, unit: "Unit 12: Further Mechanics")
  physics_a_level.topics.create!(name: "Topic 12.2: Rotational Motion", time: 6, unit: "Unit 12: Further Mechanics")
  physics_a_level.topics.create!(name: "Topic 12.3: Oscilations", time: 13, unit: "Unit 12: Further Mechanics")
  physics_a_level.topics.create!(name: "Practical Skills in Physics II", time: 4, unit: "Unit 0: Introduction to A-Level Physics")
  physics_a_level.topics.create!(name: "Mock 100% Warm Up", time: 2, milestone: true, has_grade: true)
  physics_a_level.topics.create!(name: "Mock 100%", time: 3, milestone: true, has_grade: true)


  biology_a_level = Subject.create!(
  name: "Biology A Level",
  category: :al,
  )

  biology_a_level.topics.create!(name: "Unit 1: Molecules, Diet, Transport and Health", time: 5, unit: "Unit 1: Molecules, Diet, Transport and Health")
  biology_a_level.topics.create!(name: "Topic 1: Molecules, Transport and Health", time: 30, unit: "Unit 1: Molecules, Diet, Transport and Health")
  biology_a_level.topics.create!(name: "Topic 2: Membranes, Proteins, DNA and Gene Expression", time: 35, unit: "Unit 1: Molecules, Diet, Transport and Health")
  biology_a_level.topics.create!(name: "Unit 2: Cells, Development, Biodiversity and Conservation", time: 5, unit: "Unit 2: Cells, Development, Biodiversity and Conservation")
  biology_a_level.topics.create!(name: "Topic 3: Cell Structure, Reproduction and Development", time: 30, unit: "Unit 2: Cells, Development, Biodiversity and Conservation")
  biology_a_level.topics.create!(name: "Topic 4: Plant Structure and Function, Biodiversity and Conservation", time: 35, unit: "Unit 2: Cells, Development, Biodiversity and Conservation")
  biology_a_level.topics.create!(name: "Unit 3: Practical Skills in Biology I", time: 5, unit: "Unit 3: Practical Skills in Biology I")
  biology_a_level.topics.create!(name: "50% Mock Exam Preparation", time: 10, unit: "Unit 3: Practical Skills in Biology I")
  biology_a_level.topics.create!(name: "50% Mock Exam", time: 2, unit: "Unit 3: Practical Skills in Biology I", milestone: true, has_grade: true)
  biology_a_level.topics.create!(name: "Unit 4: Energy, Environment, Microbiology and Immunity", time: 5, unit: "Unit 4: Energy, Environment, Microbiology and Immunity")
  biology_a_level.topics.create!(name: "Topic 5: Energy Flow, Ecosystems and the Environment", time: 35, unit: "Unit 4: Energy, Environment, Microbiology and Immunity")
  biology_a_level.topics.create!(name: "Topic 6: Microbiology, Immunity and Forensics", time: 35, unit: "Unit 4: Energy, Environment, Microbiology and Immunity")
  biology_a_level.topics.create!(name: "Unit 5: Respiration, Internal Environment, Coordination and Gene Technology", time: 5, unit: "Unit 5: Respiration, Internal Environment, Coordination and Gene Technology")
  biology_a_level.topics.create!(name: "Topic 7: Respiration, Muscles and the Internal Environment", time: 35, unit: "Unit 5: Respiration, Internal Environment, Coordination and Gene Technology")
  biology_a_level.topics.create!(name: "Topic 8: Coordination, Response and Gene Technology", time: 35, unit: "Unit 5: Respiration, Internal Environment, Coordination and Gene Technology")
  biology_a_level.topics.create!(name: "Unit 6: Practical Skills in Biology II", time: 5, unit: "Unit 6: Practical Skills in Biology II")
  biology_a_level.topics.create!(name: "Course Recap and Summaries", time: 5, unit: "Unit 6: Practical Skills in Biology II")
  biology_a_level.topics.create!(name: "100% Mock Exam Preparation", time: 10, unit: "Unit 6: Practical Skills in Biology II")
  biology_a_level.topics.create!(name: "100% Mock Exam", time: 2, unit: "Unit 6: Practical Skills in Biology II", milestone: true, has_grade: true)


business_a_level = Subject.create!(
  name: "Business A Level",
  category: :al,
  )

  business_a_level.topics.create!(name: "Unit 1: Marketing and People", time: 5, unit: "Unit 1: Marketing and People")
  business_a_level.topics.create!(name: "Topic 1.1 Meeting Customer Needs - Part I", time: 7, unit: "Unit 1: Marketing and People")
  business_a_level.topics.create!(name: "Topic 1.1 Meeting Customer Needs - Part II", time: 4, unit: "Unit 1: Marketing and People")
  business_a_level.topics.create!(name: "Topic 1.2 The Market - Part I", time: 8, unit: "Unit 1: Marketing and People")
  business_a_level.topics.create!(name: "Topic 1.2 The Market - Part II", time: 12, unit: "Unit 1: Marketing and People")
  business_a_level.topics.create!(name: "Topic 1.3 Marketing Mix and Strategy - Part I", time: 11, unit: "Unit 1: Marketing and People")
  business_a_level.topics.create!(name: "Topic 1.3 Marketing Mix and Strategy - Part II", time: 8, unit: "Unit 1: Marketing and People")
  business_a_level.topics.create!(name: "Topic 1.4 Managing People - Part I", time: 11, unit: "Unit 1: Marketing and People")
  business_a_level.topics.create!(name: "Topic 1.4 Managing People - Part II", time: 9, unit: "Unit 1: Marketing and People")
  business_a_level.topics.create!(name: "Topic 1.5 Entrepreneurs and Leaders - Part I", time: 8, unit: "Unit 1: Marketing and People")
  business_a_level.topics.create!(name: "Topic 1.5 Entrepreneurs and Leaders - Part II", time: 7, unit: "Unit 1: Marketing and People")
  business_a_level.topics.create!(name: "Unit 1 Assessment", time: 3, unit: "Unit 1: Marketing and People", has_grade: true)
  business_a_level.topics.create!(name: "Unit 2: Managing Business Activities", time: 5, unit: "Unit 2: Managing Business Activities")
  business_a_level.topics.create!(name: "Topic 2.1 Planning a Business and Raising Finance - Part I", time: 9, unit: "Unit 2: Managing Business Activities")
  business_a_level.topics.create!(name: "Topic 2.1 Planning a Business and Raising Finance - Part II", time: 8, unit: "Unit 2: Managing Business Activities")
  business_a_level.topics.create!(name: "Topic 2.2 Financial Planning - Part I", time: 8, unit: "Unit 2: Managing Business Activities")
  business_a_level.topics.create!(name: "Topic 2.2 Financial Planning - Part II", time: 11, unit: "Unit 2: Managing Business Activities")
  business_a_level.topics.create!(name: "Topic 2.3 Managing Finance - Part I", time: 4, unit: "Unit 2: Managing Business Activities")
  business_a_level.topics.create!(name: "Topic 2.3 Managing Finance - Part II", time: 7, unit: "Unit 2: Managing Business Activities")
  business_a_level.topics.create!(name: "Topic 2.4 Resource Management - Part I", time: 8, unit: "Unit 2: Managing Business Activities")
  business_a_level.topics.create!(name: "Topic 2.4 Resource Management - Part II", time: 7, unit: "Unit 2: Managing Business Activities")
  business_a_level.topics.create!(name: "Topic 2.5 External Influences - Part I", time: 7, unit: "Unit 2: Managing Business Activities")
  business_a_level.topics.create!(name: "Topic 2.5 External Influences - Part II", time: 4, unit: "Unit 2: Managing Business Activities")
  business_a_level.topics.create!(name: "Unit 2 Assessment", time: 2, unit: "Unit 2: Managing Business Activities", has_grade: true)
  business_a_level.topics.create!(name: "50% Mock Exam", time: 2, unit: "Unit 2: Managing Business Activities", milestone: true, has_grade: true)
  business_a_level.topics.create!(name: "Unit 3: Business Decisions and Strategy", time: 5, unit: "Unit 3: Business Decisions and Strategy")
  business_a_level.topics.create!(name: "Topic 3.1 Business Objectives and Strategy - Part I", time: 7, unit: "Unit 3: Business Decisions and Strategy")
  business_a_level.topics.create!(name: "Topic 3.1 Business Objectives and Strategy - Part II", time: 8, unit: "Unit 3: Business Decisions and Strategy")
  business_a_level.topics.create!(name: "Topic 3.2 Business Growth - Part I", time: 6, unit: "Unit 3: Business Decisions and Strategy")
  business_a_level.topics.create!(name: "Topic 3.2 Business Growth - Part II", time: 7, unit: "Unit 3: Business Decisions and Strategy")
  business_a_level.topics.create!(name: "Topic 3.3 Decision-Making Techniques - Part I", time: 11, unit: "Unit 3: Business Decisions and Strategy")
  business_a_level.topics.create!(name: "Topic 3.3 Decision-Making Techniques - Part II", time: 10, unit: "Unit 3: Business Decisions and Strategy")
  business_a_level.topics.create!(name: "Topic 3.4 Influences on Business Decisions - Part I", time: 5, unit: "Unit 3: Business Decisions and Strategy")
  business_a_level.topics.create!(name: "Topic 3.4 Influences on Business Decisions - Part II", time: 7, unit: "Unit 3: Business Decisions and Strategy")
  business_a_level.topics.create!(name: "Topic 3.5 Assessing Competitiveness - Part I", time: 4, unit: "Unit 3: Business Decisions and Strategy")
  business_a_level.topics.create!(name: "Topic 3.5 Assessing Competitiveness - Part II", time: 6, unit: "Unit 3: Business Decisions and Strategy")
  business_a_level.topics.create!(name: "Topic 3.6 Managing Change", time: 6, unit: "Unit 3: Business Decisions and Strategy")
  business_a_level.topics.create!(name: "Unit 3 Assessment", time: 2, unit: "Unit 3: Business Decisions and Strategy", has_grade: true)
  business_a_level.topics.create!(name: "Unit 4: Global Business", time: 5, unit: "Unit 4: Global Business")
  business_a_level.topics.create!(name: "Topic 4.1 Globalisation - Part I", time: 8, unit: "Unit 4: Global Business")
  business_a_level.topics.create!(name: "Topic 4.1 Globalisation - Part II", time: 7, unit: "Unit 4: Global Business")
  business_a_level.topics.create!(name: "Topic 4.2 Global Markets and Business Expansion - Part I", time: 8, unit: "Unit 4: Global Business")
  business_a_level.topics.create!(name: "Topic 4.2 Global Markets and Business Expansion - Part II", time: 7, unit: "Unit 4: Global Business")
  business_a_level.topics.create!(name: "Topic 4.3 Global Marketing - Part I", time: 6, unit: "Unit 4: Global Business")
  business_a_level.topics.create!(name: "Topic 4.3 Global Marketing - Part II", time: 4, unit: "Unit 4: Global Business")
  business_a_level.topics.create!(name: "Topic 4.4 Global Industries and Companies - Part I", time: 6, unit: "Unit 4: Global Business")
  business_a_level.topics.create!(name: "Topic 4.4 Global Industries and Companies - Part II", time: 4, unit: "Unit 4: Global Business")
  business_a_level.topics.create!(name: "Unit 4 Assessment", time: 2, unit: "Unit 4: Global Business", has_grade: true)
  business_a_level.topics.create!(name: "100% Mock Exam", time: 2, unit: "Unit 4: Global Business", milestone: true, has_grade: true)


economics_a_level = Subject.create!(
  name: "Economics A Level",
  category: :al,
  )

  economics_a_level.topics.create!(name: "Unit 1 - Markets in Action", time: 5, unit: "Unit 1 - Markets in Action")
  economics_a_level.topics.create!(name: "Topic 1.1 Introductory Concepts: Part I", time: 7, unit: "Unit 1 - Markets in Action")
  economics_a_level.topics.create!(name: "Topic 1.1 Introductory Concepts: Part II", time: 7, unit: "Unit 1 - Markets in Action")
  economics_a_level.topics.create!(name: "Topic 1.1 Introductory Concepts: Part III", time: 7, unit: "Unit 1 - Markets in Action")
  economics_a_level.topics.create!(name: "Topic 1.2 Consumer Behaviour and Demand: Part I", time: 9, unit: "Unit 1 - Markets in Action")
  economics_a_level.topics.create!(name: "Topic 1.2 Consumer Behaviour and Demand: Part II", time: 5, unit: "Unit 1 - Markets in Action")
  economics_a_level.topics.create!(name: "Topic 1.3 Supply", time: 8, unit: "Unit 1 - Markets in Action")
  economics_a_level.topics.create!(name: "Topic 1.4 Price Determination: Part I", time: 6, unit: "Unit 1 - Markets in Action")
  economics_a_level.topics.create!(name: "Topic 1.4 Price Determination: Part II", time: 7, unit: "Unit 1 - Markets in Action")
  economics_a_level.topics.create!(name: "Topic 1.5 Market Failure: Part I", time: 7, unit: "Unit 1 - Markets in Action")
  economics_a_level.topics.create!(name: "Topic 1.5 Market Failure: Part II", time: 6, unit: "Unit 1 - Markets in Action")
  economics_a_level.topics.create!(name: "Topic 1.5 Market Failure: Part III", time: 8, unit: "Unit 1 - Markets in Action")
  economics_a_level.topics.create!(name: "Topic 1.6 Government Intervention in Markets", time: 8, unit: "Unit 1 - Markets in Action")
  economics_a_level.topics.create!(name: "Unit 1 Assessments", time: 4, unit: "Unit 1 - Markets in Action", has_grade: true)
  economics_a_level.topics.create!(name: "Unit 2 - Macroeconomic Performance And Policiy", time: 5, unit: "Unit 2 - Macroeconomic Performance And Policiy")
  economics_a_level.topics.create!(name: "Topic 2.1 Measures of Economic Performance: Part I", time: 7, unit: "Unit 2 - Macroeconomic Performance And Policiy")
  economics_a_level.topics.create!(name: "Topic 2.1 Measures of Economic Performance: Part II", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy")
  economics_a_level.topics.create!(name: "Topic 2.2 Aggregate Demand (AD): Part I", time: 8, unit: "Unit 2 - Macroeconomic Performance And Policiy")
  economics_a_level.topics.create!(name: "Topic 2.2 Aggregate Demand (AD): Part II", time: 7, unit: "Unit 2 - Macroeconomic Performance And Policiy")
  economics_a_level.topics.create!(name: "Topic 2.3 Aggregate Supply (AS)", time: 9, unit: "Unit 2 - Macroeconomic Performance And Policiy")
  economics_a_level.topics.create!(name: "Topic 2.4 National Income: Part I", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy")
  economics_a_level.topics.create!(name: "Topic 2.4 National Income: Part II", time: 7, unit: "Unit 2 - Macroeconomic Performance And Policiy")
  economics_a_level.topics.create!(name: "Topic 2.5 Economic Growth: Part I", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy")
  economics_a_level.topics.create!(name: "Topic 2.5 Economic Growth: Part II", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy")
  economics_a_level.topics.create!(name: "Topic 2.6 Macroeconomic Objectives and Policies: Part I", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy")
  economics_a_level.topics.create!(name: "Topic 2.6 Macroeconomic Objectives and Policies: Part II", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy")
  economics_a_level.topics.create!(name: "Unit 2 Assessments: Exam Preparation", time: 6, unit: "Unit 2 - Macroeconomic Performance And Policiy", has_grade: true)
  economics_a_level.topics.create!(name: "Mock Exam 50%", time: 2, unit: "Unit 2 - Macroeconomic Performance And Policiy", milestone: true, has_grade: true)
  economics_a_level.topics.create!(name: "Unit 3 - Business Behaviour", time: 5, unit: "Unit 3 - Business Behaviour")
  economics_a_level.topics.create!(name: "Topic 3.1 Types and Sizes of Business", time: 6, unit: "Unit 3 - Business Behaviour")
  economics_a_level.topics.create!(name: "Topic 3.2 Revenues, Costs and Profits: Part I", time: 6, unit: "Unit 3 - Business Behaviour")
  economics_a_level.topics.create!(name: "Topic 3.2 Revenues, Costs and Profits: Part II", time: 7, unit: "Unit 3 - Business Behaviour")
  economics_a_level.topics.create!(name: "Topic 3.3 Market Structures and Contestability: Part I", time: 6, unit: "Unit 3 - Business Behaviour")
  economics_a_level.topics.create!(name: "Topic 3.3 Market Structures and Contestability: Part II", time: 6, unit: "Unit 3 - Business Behaviour")
  economics_a_level.topics.create!(name: "Topic 3.3 Market Structures and Contestability: Part III", time: 9, unit: "Unit 3 - Business Behaviour")
  economics_a_level.topics.create!(name: "Topic 3.4 Labour Markets", time: 10, unit: "Unit 3 - Business Behaviour")
  economics_a_level.topics.create!(name: "Topic 3.5 Government Intervention", time: 6, unit: "Unit 3 - Business Behaviour")
  economics_a_level.topics.create!(name: "Unit 3 Assessments", time: 2, unit: "Unit 3 - Business Behaviour", has_grade: true)
  economics_a_level.topics.create!(name: "Unit 4  - Developments in the Global Economy", time: 5, unit: "Unit 4  - Developments in the Global Economy")
  economics_a_level.topics.create!(name: "Topic 4.1 Causes and Effects of Globalisation", time: 4, unit: "Unit 4  - Developments in the Global Economy")
  economics_a_level.topics.create!(name: "Topic 4.2 Trade and the Global Economy - Part I", time: 8, unit: "Unit 4  - Developments in the Global Economy")
  economics_a_level.topics.create!(name: "Topic 4.2 Trade and the Global Economy - Part II", time: 8, unit: "Unit 4  - Developments in the Global Economy")
  economics_a_level.topics.create!(name: "Topic 4.3 Balance of Payments, Exchange Rates and International Competitiveness", time: 8, unit: "Unit 4  - Developments in the Global Economy")
  economics_a_level.topics.create!(name: "Topic 4.4 Poverty and Inequality", time: 7, unit: "Unit 4  - Developments in the Global Economy")
  economics_a_level.topics.create!(name: "Topic 4.5 Role of the State in the Macroeconomy - Part I", time: 6, unit: "Unit 4  - Developments in the Global Economy")
  economics_a_level.topics.create!(name: "Topic 4.5 Role of the State in the Macroeconomy - Part II", time: 4, unit: "Unit 4  - Developments in the Global Economy")
  economics_a_level.topics.create!(name: "Topic 4.6 Growth and Development in Developing, Emerging and Developed Economies", time: 8, unit: "Unit 4  - Developments in the Global Economy")
  economics_a_level.topics.create!(name: "Unit 4 Assessments", time: 6, unit: "Unit 4  - Developments in the Global Economy", has_grade: true)
  economics_a_level.topics.create!(name: "Mock Exam 100%", time: 2, unit: "Unit 4  - Developments in the Global Economy", milestone: true, has_grade: true)


  psychology_a_level = Subject.create!(
    name: "Psychology A Level",
    category: :al,
    )

    psychology_a_level.topics.create!(name: "Topic A - Social Psychology: Obedience [Part 1]", time: 12, unit: "Unit 1: Social and Cognitive Psychology")
    psychology_a_level.topics.create!(name: "Topic A - Social Psychology: Conformity and Minority Influence [Part 2]", time: 10, unit: "Unit 1: Social and Cognitive Psychology")
    psychology_a_level.topics.create!(name: "Topic A - Social Psychology: Studies/Research  [Part 3]", time: 6, unit: "Unit 1: Social and Cognitive Psychology")
    psychology_a_level.topics.create!(name: "Topic A - Social Psychology: Research Methods I [Part 4]", time: 15, unit: "Unit 1: Social and Cognitive Psychology")
    psychology_a_level.topics.create!(name: "Topic A - Social Psychology: Revision/ Assignments [Part 5]", time: 21, unit: "Unit 1: Social and Cognitive Psychology")
    psychology_a_level.topics.create!(name: "Topic B - Cognitive Psychology: Memory [Part 1]", time: 14, unit: "Unit 1: Social and Cognitive Psychology")
    psychology_a_level.topics.create!(name: "Topic B - Cognitive Psychology: Studies/Research [Part 2]", time: 6, unit: "Unit 1: Social and Cognitive Psychology")
    psychology_a_level.topics.create!(name: "Topic B - Cognitive Psychology: Research Methods II [Part 3]", time: 12, unit: "Unit 1: Social and Cognitive Psychology")
    psychology_a_level.topics.create!(name: "Topic B - Cognitive Psychology: Revision/ Assignments [Part 4]", time: 3, unit: "Unit 1: Social and Cognitive Psychology")
    psychology_a_level.topics.create!(name: "Topic C - Biological Psychology:  Structure & Function of Brain  [Part 1]", time: 5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
    psychology_a_level.topics.create!(name: "Topic C - Biological Psychology: Aggression – The Role of Genes and Hormones [Part 2]", time: 5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
    psychology_a_level.topics.create!(name: "Topic C - Biological Psychology: Body Rhythms [Part 3]", time: 5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
    psychology_a_level.topics.create!(name: "Topic C - Biological Psychology: Body Rhythms – Studies/Research  [Part 4]", time: 6, unit: "Unit 2: Biological Psychology, Learning theories & Development")
    psychology_a_level.topics.create!(name: "Topic C - Biological Psychology: Research Methods III [Part 5]", time: 10, unit: "Unit 2: Biological Psychology, Learning theories & Development")
    psychology_a_level.topics.create!(name: "Topic C - Revision/ Assignments [Part 6]", time: 9, unit: "Unit 2: Biological Psychology, Learning theories & Development")
    psychology_a_level.topics.create!(name: "Topic D - Learning Theories & Development: Behaviourism & Conditioning [Part 1]", time: 7, unit: "Unit 2: Biological Psychology, Learning theories & Development")
    psychology_a_level.topics.create!(name: "Topic D – Learning Theories & Development: Social Learning Theory [Part 2]", time: 5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
    psychology_a_level.topics.create!(name: "Topic D – Learning Theories & Development: Freud’s Theory of Development [Part 3]", time: 5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
    psychology_a_level.topics.create!(name: "Topic D – Learning Theories & Development: Therapies/Treatment [Part 4]", time: 5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
    psychology_a_level.topics.create!(name: "Topic D – Learning Theories & Development: Studies/Research  [Part 5]", time: 6, unit: "Unit 2: Biological Psychology, Learning theories & Development")
    psychology_a_level.topics.create!(name: "Topic D – Learning Theories & Development: Research Methods IV [Part 6]", time: 16, unit: "Unit 2: Biological Psychology, Learning theories & Development")
    psychology_a_level.topics.create!(name: "Topic D – Learning Theories & Development: Revision/ Assignments  [Part 7]", time: 11.5, unit: "Unit 2: Biological Psychology, Learning theories & Development")
    psychology_a_level.topics.create!(name: "50% Mock Exam", time: 3.5, unit: "Unit 2: Biological Psychology, Learning theories & Development", milestone: true, has_grade: true)
    psychology_a_level.topics.create!(name: "Topic E - Developmental Psychology - Attachment [Part 1]", time: 8.5, unit: "Unit 3: Applications of Psychology")
    psychology_a_level.topics.create!(name: "Topic E - Developmental Psychology: Cognitive and Language Development [Part 2]", time: 10, unit: "Unit 3: Applications of Psychology")
    psychology_a_level.topics.create!(name: "Topic E - Developmental Psychology: Social and Emotional Development [Part 3]", time: 6, unit: "Unit 3: Applications of Psychology")
    psychology_a_level.topics.create!(name: "Topic E - Developmental Psychology: Learning theories [Part 4]", time: 5, unit: "Unit 3: Applications of Psychology")
    psychology_a_level.topics.create!(name: "Topic E - Developmental Psychology: Studies/Research  [Part 5]", time: 6, unit: "Unit 3: Applications of Psychology")
    psychology_a_level.topics.create!(name: "Topic E - Developmental Psychology: Research Methods V/ Issues [Part 6]", time: 6, unit: "Unit 3: Applications of Psychology")
    psychology_a_level.topics.create!(name: "Topic E – Developmental Psychology: Revision/ Assignments [Part 7]", time: 2.5, unit: "Unit 3: Applications of Psychology")
    psychology_a_level.topics.create!(name: "Topic F - Criminal Psychology: Explanations for Crime and Anti-social Behaviour [Part 1]", time: 6, unit: "Unit 3: Applications of Psychology")
    psychology_a_level.topics.create!(name: "Topic F - Criminal Psychology: (Understanding) the Offender [Part 2]", time: 5, unit: "Unit 3: Applications of Psychology")
    psychology_a_level.topics.create!(name: "Topic F – Criminal Psychology: Factors that influence the identification of Offenders [Part 3]", time: 6, unit: "Unit 3: Applications of Psychology")
    psychology_a_level.topics.create!(name: "Topic F – Criminal Psychology: Treatment [Part 4]", time: 5, unit: "Unit 3: Applications of Psychology")
    psychology_a_level.topics.create!(name: "Topic F – Criminal Psychology: Studies/Research  [Part 5]", time: 6, unit: "Unit 3: Applications of Psychology")
    psychology_a_level.topics.create!(name: "Topic F – Criminal Psychology: Assignments", time: 4.5, unit: "Unit 3: Applications of Psychology")
    psychology_a_level.topics.create!(name: "Topic G - Clinical Psychology: Diagnosis - Definitions and Debates [Part 1]", time: 10, unit: "Unit 4: Clinical Psychology & Psychological Skills")
    psychology_a_level.topics.create!(name: "Topic G - Clinical Psychology: Mental Health Disorders and Explanations [Part 2]", time: 10, unit: "Unit 4: Clinical Psychology & Psychological Skills")
    psychology_a_level.topics.create!(name: "Topic G - Clinical Psychology: Treatment [Part 3]", time: 10, unit: "Unit 4: Clinical Psychology & Psychological Skills")
    psychology_a_level.topics.create!(name: "Topic G - Clinical Psychology: Studies/ Research [Part 4]", time: 6, unit: "Unit 4: Clinical Psychology & Psychological Skills")
    psychology_a_level.topics.create!(name: "Topic G - Clinical Psychology: Research Methods VII [Part 5]", time: 10, unit: "Unit 4: Clinical Psychology & Psychological Skills")
    psychology_a_level.topics.create!(name: "Topic G - Clinical Psychology: Revision/ Assignments [Part 6]", time: 10.5, unit: "Unit 4: Clinical Psychology & Psychological Skills")
    psychology_a_level.topics.create!(name: "Topic H - Psychological Skills: Key questions in Society [Part 1]", time: 16, unit: "Unit 4: Clinical Psychology & Psychological Skills")
    psychology_a_level.topics.create!(name: "Topic H - Psychological Skills: Issues & Debates in Psychology [Part 2]", time: 24, unit: "Unit 4: Clinical Psychology & Psychological Skills")
    psychology_a_level.topics.create!(name: "Topic H - Psychological Skills: Summary of Research Methods [Part 3]", time: 18, unit: "Unit 4: Clinical Psychology & Psychological Skills")
    psychology_a_level.topics.create!(name: "Topic H - Psychological Skills: Assignments", time: 4, unit: "Unit 4: Clinical Psychology & Psychological Skills")
    psychology_a_level.topics.create!(name: "100% Mock Exam", time: 8, unit: "Unit 4: Clinical Psychology & Psychological Skills", milestone: true, has_grade: true)

sociology_a_level = Subject.create!(
  name: "Sociology A Level",
  category: :al,
  )

  sociology_a_level.topics.create!(name: "Topic 1.1: What is sociology?", time: 3, unit: "Unit 1: Introduction to sociology")
  sociology_a_level.topics.create!(name: "Topic 1.2: Structural perspectives", time: 7, unit: "Unit 1: Introduction to sociology")
  sociology_a_level.topics.create!(name: "Topic 1.3: Interactionist perspectives", time: 8, unit: "Unit 1: Introduction to sociology")
  sociology_a_level.topics.create!(name: "Topic 2.1: Learning socialisation and the role of culture", time: 10, unit: "Unit 2: Socialisation and who we are")
  sociology_a_level.topics.create!(name: "Topic 2.2: Social control and social order", time: 10, unit: "Unit 2: Socialisation and who we are")
  sociology_a_level.topics.create!(name: "Topic 2.3: Social identity and different individual characteristics", time: 12, unit: "Unit 2: Socialisation and who we are")
  sociology_a_level.topics.create!(name: "Topic 3.1: Introduction to research", time: 10, unit: "Unit 3: Research methods")
  sociology_a_level.topics.create!(name: "Topic 3.2: Types of research methods", time: 10, unit: "Unit 3: Research methods")
  sociology_a_level.topics.create!(name: "Topic 3.3: How to approach sociological research", time: 13, unit: "Unit 3: Research methods")
  sociology_a_level.topics.create!(name: "Topic 4.1: Structuralist view of the family", time: 10, unit: "Unit 4: The family")
  sociology_a_level.topics.create!(name: "Topic 4.2: Marriage, social change and family diversity", time: 10, unit: "Unit 4: The family")
  sociology_a_level.topics.create!(name: "Topic 4.3: Gender and the family", time: 10, unit: "Unit 4: The family")
  sociology_a_level.topics.create!(name: "Topic 4.4: Childhood and social change", time: 10, unit: "Unit 4: The family")
  sociology_a_level.topics.create!(name: "Topic 4.5: Changes in life expectancy and motherhood/fatherhood", time: 13, unit: "Unit 4: The family")
  sociology_a_level.topics.create!(name: "50% Mock Exam", time: 3, unit: "50% Mock Exam", milestone: true, has_grade: true)
  sociology_a_level.topics.create!(name: "Topic 5.1: Theories on the role of education", time: 8, unit: "Unit 5: Education")
  sociology_a_level.topics.create!(name: "Topic 5.2: The role of education on social mobility", time: 7, unit: "Unit 5: Education")
  sociology_a_level.topics.create!(name: "Topic 5.3: Influences on the curriculum", time: 8, unit: "Unit 5: Education")
  sociology_a_level.topics.create!(name: "Topic 5.4: Intelligence and educational attainment", time: 7, unit: "Unit 5: Education")
  sociology_a_level.topics.create!(name: "Topic 5.5: Social class and educational attainment", time: 7, unit: "Unit 5: Education")
  sociology_a_level.topics.create!(name: "Topic 5.6: Ethnicity and educational attainment", time: 8, unit: "Unit 5: Education")
  sociology_a_level.topics.create!(name: "Topic 5.7: Gender and educational attainment", time: 11, unit: "Unit 5: Education")
  sociology_a_level.topics.create!(name: "Topic 6.1: The Media in a Global Perspective", time: 6, unit: "Unit 6: Media")
  sociology_a_level.topics.create!(name: "Topic 6.2: Theories of the Media", time: 8, unit: "Unit 6: Media")
  sociology_a_level.topics.create!(name: "Topic 6.3: The impact of the new Media", time: 7, unit: "Unit 6: Media")
  sociology_a_level.topics.create!(name: "Topic 6.4: Media representations", time: 6, unit: "Unit 6: Media")
  sociology_a_level.topics.create!(name: "Topic 6.5: Media Effects", time: 11, unit: "Unit 6: Media")
  sociology_a_level.topics.create!(name: "Topic 7.1: Religion and society", time: 8, unit: "Unit 7: Religion")
  sociology_a_level.topics.create!(name: "Topic 7.2: Religion and social order", time: 6, unit: "Unit 7: Religion")
  sociology_a_level.topics.create!(name: "Topic 7.3: Gender and religion", time: 7, unit: "Unit 7: Religion")
  sociology_a_level.topics.create!(name: "Topic 7.4: Religion and social change", time: 7, unit: "Unit 7: Religion")
  sociology_a_level.topics.create!(name: "Topic 7.5: The secularization debate", time: 8, unit: "Unit 7: Religion")
  sociology_a_level.topics.create!(name: "Topic 7.6: Religion and postmodernity", time: 8, unit: "Unit 7: Religion")
  sociology_a_level.topics.create!(name: "Topic 8.1: Perspectives on globalisation", time: 8, unit: "Unit 8: Globalisation")
  sociology_a_level.topics.create!(name: "Topic 8.2: Globalisation and identity", time: 7, unit: "Unit 8: Globalisation")
  sociology_a_level.topics.create!(name: "Topic 8.3: Globalisation, power and politics", time: 8, unit: "Unit 8: Globalisation")
  sociology_a_level.topics.create!(name: "Topic 8.4: Globalisation, poverty and inequality", time: 7, unit: "Unit 8: Globalisation")
  sociology_a_level.topics.create!(name: "Topic 8.5: Globalisation and migration", time: 8, unit: "Unit 8: Globalisation")
  sociology_a_level.topics.create!(name: "Topic 8.6: Globalisation and crime", time: 10, unit: "Unit 8: Globalisation")
  sociology_a_level.topics.create!(name: "100% Mock Exam", time: 3, unit: "100% Mock Exam", milestone: true, has_grade: true)

history_a_level = Subject.create!(
  name: "History A Level",
  category: :al,
  )

  history_a_level.topics.create!(name: "Topic 1.1: Political reaction and economic change –Alexander III and Nicholas II, 1881–1903", time: 20, unit: "Unit 1: Depth Study with Interpretations: Russia in Revolution (1881-1917)")
  history_a_level.topics.create!(name: "Topic 1.2: The First Revolution and its impact, 1903–14", time: 20, unit: "Unit 1: Depth Study with Interpretations: Russia in Revolution (1881-1917)")
  history_a_level.topics.create!(name: "Topic 1.3: The end of Romanov rule, 1914–17", time: 21, unit: "Unit 1: Depth Study with Interpretations: Russia in Revolution (1881-1917)")
  history_a_level.topics.create!(name: "Topic 1.4: The Bolshevik seizure of power October 1917", time: 21, unit: "Unit 1: Depth Study with Interpretations: Russia in Revolution (1881-1917)")
  history_a_level.topics.create!(name: "Unit 1 Assessment: Depth Study with Interpretations: Russia in Revolution (1881-1917)", time: 1, unit: "Unit 1: Depth Study with Interpretations: Russia in Revolution (1881-1917)")
  history_a_level.topics.create!(name: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)", time: 20, unit: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)")
  history_a_level.topics.create!(name: "Topic 2.1: Order and disorder,1900–76", time: 21, unit: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)")
  history_a_level.topics.create!(name: "Topic 2.2: The impact of the world on China, 1900–76", time: 21, unit: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)")
  history_a_level.topics.create!(name: "Topic 2.3: Economic changes, 1900–76", time: 21, unit: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)")
  history_a_level.topics.create!(name: "Topic 2.4: Social and cultural changes, 1900–76", time: 2, unit: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)")
  history_a_level.topics.create!(name: "Unit 2 Assessment: Breadth Study with Source Evaluation: China (1900-1976)", time: 1, unit: "Unit 2: Breadth Study with Source Evaluation: China (1900-1976)")
  history_a_level.topics.create!(name: "50% Mock Exam  (Comprising of Units 1 and 2)", time: 2, unit: "50% Mock Exam  (Comprising of Units 1 and 2)", milestone: true, has_grade: true)
  history_a_level.topics.create!(name: "Topic 3.1: ‘Free at last’, 1865–77", time: 21, unit: "Unit 3: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)")
  history_a_level.topics.create!(name: "Topic 3.2: The triumph of ‘Jim Crow’, 1883– c1900", time: 22, unit: "Unit 3: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)")
  history_a_level.topics.create!(name: "Topic 3.3: Roosevelt and race relations, 1933–45", time: 21, unit: "Unit 3: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)")
  history_a_level.topics.create!(name: "Topic 3.4: ‘I have a dream’, 1954–68", time: 22, unit: "Unit 3: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)")
  history_a_level.topics.create!(name: "Topic 3.5: Race relations and Obama’s campaign for the presidency, c2000–09", time: 23.5, unit: "Unit 3: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)")
  history_a_level.topics.create!(name: "Unit 3 Assessment: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)", time: 1, unit: "Unit 3: Thematic Study with Source Evaluation: Civil Rights and Race Relations in USA (1865-2005)")
  history_a_level.topics.create!(name: "Topic 4.1: Historical interpretations: what explains the outbreak, course and impact of the Korean War in the period 1950–53?", time: 21, unit: "Unit 4: International Study with Historical Interpretations: Option 1D: The Cold War and Hot War in Asia (1945-90)")
  history_a_level.topics.create!(name: "Topic 4.2: The emergence of the Cold War in Southeast Asia, 1945–60", time: 20, unit: "Unit 4: International Study with Historical Interpretations: Option 1D: The Cold War and Hot War in Asia (1945-90)")
  history_a_level.topics.create!(name: "Topic 4.3: War in Indo-China, 1960–73", time: 20, unit: "Unit 4: International Study with Historical Interpretations: Option 1D: The Cold War and Hot War in Asia (1945-90)")
  history_a_level.topics.create!(name: "Topic 4.4: South-East Asia without the West: the fading of the Cold War, 1973–90", time: 21.5, unit: "Unit 4: International Study with Historical Interpretations: Option 1D: The Cold War and Hot War in Asia (1945-90)")
  history_a_level.topics.create!(name: "Unit 4 Assessment:  International Study with Historical Interpretations: Option 1D: The Cold War and Hot War in Asia (1945-90)", time: 1, unit: "Unit 4: International Study with Historical Interpretations: Option 1D: The Cold War and Hot War in Asia (1945-90)")
  history_a_level.topics.create!(name: "100% Mock Exam  - Comprising of Units 3 and 4", time: 2, unit: "100% Mock Exam  - Comprising of Units 3 and 4", milestone: true, has_grade: true)


geography_a_level = Subject.create!(
  name: "Geography A Level",
  category: :al,
  )

geography_a_level.topics.create!(name: "Getting Started", time: 3, unit: "Getting Started")
geography_a_level.topics.create!(name: "Topic 1.1 - The Hydrological System", time: 3, unit: "Unit 1 - Hydrology and Fluvial Geography")
geography_a_level.topics.create!(name: "Topic 1.2 - The Drainage Basin System", time: 3, unit: "Unit 1 - Hydrology and Fluvial Geography")
geography_a_level.topics.create!(name: "Topic 1.3 - Discharge Relationships Within Drainage Basins", time: 3, unit: "Unit 1 - Hydrology and Fluvial Geography")
geography_a_level.topics.create!(name: "Topic 1.4 - River Channel Processes and Landforms", time: 3, unit: "Unit 1 - Hydrology and Fluvial Geography")
geography_a_level.topics.create!(name: "Topic 1.5 - The Human Impact", time: 3, unit: "Unit 1 - Hydrology and Fluvial Geography")
geography_a_level.topics.create!(name: "Topic 1.6 - Flooding Case Study: Ahr Valley, Germany and Belgium", time: 5, unit: "Unit 1 - Hydrology and Fluvial Geography")
geography_a_level.topics.create!(name: "Unit 1 Assessment: Exam Preparation", time: 10, unit: "Unit 1 - Hydrology and Fluvial Geography")
geography_a_level.topics.create!(name: "Topic 2.1 - Diurnal Energy Budgets", time: 3, unit: "Unit 2 - Atmosphere and Weather")
geography_a_level.topics.create!(name: "Topic 2.2 - The Global Energy Budget", time: 3, unit: "Unit 2 - Atmosphere and Weather")
geography_a_level.topics.create!(name: "Topic 2.3 - Weather Processes and Phenomena", time: 3, unit: "Unit 2 - Atmosphere and Weather")
geography_a_level.topics.create!(name: "Topic 2.4 - The Human Impact on the Atmosphere and Weather", time: 3, unit: "Unit 2 - Atmosphere and Weather")
geography_a_level.topics.create!(name: "Topic 2.5 - Case Study: Urban Microclimates (Heat Islands)", time: 4, unit: "Unit 2 - Atmosphere and Weather")
geography_a_level.topics.create!(name: "Unit 2 Assessment: Exam Preparation", time: 10, unit: "Unit 2 - Atmosphere and Weather")
geography_a_level.topics.create!(name: "Topic 3.1 - Plate Tectonics", time: 3, unit: "Unit 3 - Rocks and Weathering")
geography_a_level.topics.create!(name: "Topic 3.2 - Weathering", time: 3, unit: "Unit 3 - Rocks and Weathering")
geography_a_level.topics.create!(name: "Topic 3.3 - Slope Processes", time: 3, unit: "Unit 3 - Rocks and Weathering")
geography_a_level.topics.create!(name: "Topic 3.4 - The Human Impact on Rocks and Weathering", time: 3, unit: "Unit 3 - Rocks and Weathering")
geography_a_level.topics.create!(name: "Topic 3.5 - Case Study: Coastal Landslide in Alta County, Norway", time: 5, unit: "Unit 3 - Rocks and Weathering")
geography_a_level.topics.create!(name: "Unit 3 Assessment: Exam Preparation", time: 10, unit: "Unit 3 - Rocks and Weathering")
geography_a_level.topics.create!(name: "Topic 4.1 - Population Change", time: 3, unit: "Unit 4 - Population")
geography_a_level.topics.create!(name: "Topic 4.2 - Demographic Transition", time: 3, unit: "Unit 4 - Population")
geography_a_level.topics.create!(name: "Topic 4.3 - Population-resource relationships", time: 3, unit: "Unit 4 - Population")
geography_a_level.topics.create!(name: "Topic 4.4 - The Management of Natural Increase CASE STUDY", time: 5, unit: "Unit 4 - Population")
geography_a_level.topics.create!(name: "Unit 4 Assessment: Exam Preparation", time: 10, unit: "Unit 4 - Population")
geography_a_level.topics.create!(name: "Topic 5.1 - Migration as a Component of Population Change", time: 3, unit: "Unit 5 - Migration")
geography_a_level.topics.create!(name: "Topic 5.2 - Internal Migration", time: 3, unit: "Unit 5 - Migration")
geography_a_level.topics.create!(name: "Topic 5.3 - International Migration", time: 3, unit: "Unit 5 - Migration")
geography_a_level.topics.create!(name: "Topic 5.4 - The Management of International Migration", time: 3, unit: "Unit 5 - Migration")
geography_a_level.topics.create!(name: "Unit 5 Assessment: Exam Preparation", time: 10, unit: "Unit 5 - Migration")
geography_a_level.topics.create!(name: "Topic 6.1 - Changes in Rural Settlements", time: 3, unit: "Unit 6 - Settlement Dynamics")
geography_a_level.topics.create!(name: "Topic 6.2 - Urban Trends and Issues of Urbanisation", time: 3, unit: "Unit 6 - Settlement Dynamics")
geography_a_level.topics.create!(name: "Topic 6.3 - The Changing Structure of Urban Settlements", time: 3, unit: "Unit 6 - Settlement Dynamics")
geography_a_level.topics.create!(name: "Topic 6.4 - The Management of Urban Settlements - CASE STUDY", time: 5, unit: "Unit 6 - Settlement Dynamics")
geography_a_level.topics.create!(name: "Unit 6 Assessment: Exam Preparation", time: 10, unit: "Unit 6 - Settlement Dynamics")
geography_a_level.topics.create!(name: "Mock 50%", time: 3, unit: "Mock 50%", milestone: true, has_grade: true)
geography_a_level.topics.create!(name: "Topic 7.1 - Coastal Processes", time: 3, unit: "Unit 7 - Coastal Environments")
geography_a_level.topics.create!(name: "Topic 7.2 - Sediment Budgets and Erosion", time: 3, unit: "Unit 7 - Coastal Environments")
geography_a_level.topics.create!(name: "Topic 7.3 -Characteristics and Formation of Coastal Landforms", time: 3, unit: "Unit 7 - Coastal Environments")
geography_a_level.topics.create!(name: "Topic 7.4 -Coral Reefs", time: 5, unit: "Unit 7 - Coastal Environments")
geography_a_level.topics.create!(name: "Topic 7.5 - Sustainable Management of Coasts", time: 3, unit: "Unit 7 - Coastal Environments")
geography_a_level.topics.create!(name: "Topic 7.6 -CASE STUDY: The Battle Against the Sea", time: 3, unit: "Unit 7 - Coastal Environments")
geography_a_level.topics.create!(name: "Unit 7 Assessment: Exam Preparation", time: 10, unit: "Unit 7 - Coastal Environments")
geography_a_level.topics.create!(name: "Topic 8.1 - Hazards Resulting from Tectonic Processes", time: 3, unit: "Unit 8 - Hazardous Environments")
geography_a_level.topics.create!(name: "Topic 8.2 - Hazards Resulting from Tectonic Processes Case Study (Haiti)", time: 5, unit: "Unit 8 - Hazardous Environments")
geography_a_level.topics.create!(name: "Topic 8.3 - Hazards Resulting from Mass Movements", time: 3, unit: "Unit 8 - Hazardous Environments")
geography_a_level.topics.create!(name: "Topic 8.4 - Hazards Resulting from Mass Movements (Case Study)", time: 5, unit: "Unit 8 - Hazardous Environments")
geography_a_level.topics.create!(name: "Topic 8.5 - Hazards Resulting from Atmospheric Disturbances", time: 3, unit: "Unit 8 - Hazardous Environments")
geography_a_level.topics.create!(name: "Topic 8.6 - Hazards Resulting from Atmospheric Disturbances (Case Study)", time: 5, unit: "Unit 8 - Hazardous Environments")
geography_a_level.topics.create!(name: "Topic 8.7 - Sustainable Management in Hazardous Environments (Case Study)", time: 5, unit: "Unit 8 - Hazardous Environments")
geography_a_level.topics.create!(name: "Unit 8 Assessment: Exam Preparation", time: 10, unit: "Unit 8 - Hazardous Environments")
geography_a_level.topics.create!(name: "Topic 9.1 - Agricultural Systems and Food Production", time: 3, unit: "Unit 9 - Production, Location, and Change")
geography_a_level.topics.create!(name: "Topic 9.2 - The Management of Agricultural Change CASE STUDY", time: 5, unit: "Unit 9 - Production, Location, and Change")
geography_a_level.topics.create!(name: "Topic 9.3 - Manufacturing and Related Service Industry", time: 3, unit: "Unit 9 - Production, Location, and Change")
geography_a_level.topics.create!(name: "Topic 9.4 - The Management of Manufacturing Change CASE STUDY", time: 5, unit: "Unit 9 - Production, Location, and Change")
geography_a_level.topics.create!(name: "Unit 9 Assessment: Exam Preparation", time: 3, unit: "Unit 9 - Production, Location, and Change")
geography_a_level.topics.create!(name: "Topic 10.1 - Sustainable Energy Supplies", time: 3, unit: "Unit 10 - Environmental Management")
geography_a_level.topics.create!(name: "Topic 10.2 - The Management of Energy Supply CASE STUDY", time: 3, unit: "Unit 10 - Environmental Management")
geography_a_level.topics.create!(name: "Topic 10.3 - Environmental Degradation", time: 5, unit: "Unit 10 - Environmental Management")
geography_a_level.topics.create!(name: "Topic 10.4 - The Management of Degraded Environments CASE STUDY", time: 10, unit: "Unit 10 - Environmental Management")
geography_a_level.topics.create!(name: "Unit 10 Assessment: Exam Preparation", time: 10, unit: "Unit 10 - Environmental Management")
geography_a_level.topics.create!(name: "Mock 100%", time: 3, unit: "Mock 100%", milestone: true, has_grade: true)

english_a_level = Subject.create!(
  name: "English A Level",
  category: :al,
  )

english_a_level.topics.create!(name: "Topic 1: Word Classes", time: 6, unit: "Unit 1 Linguistic Features")
english_a_level.topics.create!(name: "Topic 2: Syntax", time: 6, unit: "Unit 1 Linguistic Features")
english_a_level.topics.create!(name: "Topic 3: Lexis", time: 8, unit: "Unit 1 Linguistic Features")
english_a_level.topics.create!(name: "Topic 4: Tone and Tonal Shifts", time: 5, unit: "Unit 1 Linguistic Features")
english_a_level.topics.create!(name: "Topic 5: Phonology", time: 8, unit: "Unit 1 Linguistic Features")
english_a_level.topics.create!(name: "Topic 1 - Figurative Language", time: 5, unit: "Unit 2 - Literary Features")
english_a_level.topics.create!(name: "Topic 2 - Image and Symbols", time: 7, unit: "Unit 2 - Literary Features")
english_a_level.topics.create!(name: "Topic 3 - Narrative Features", time: 7, unit: "Unit 2 - Literary Features")
english_a_level.topics.create!(name: "Topic 4 - Literary Genre - Tragedy", time: 4, unit: "Unit 2 - Literary Features")
english_a_level.topics.create!(name: "Topic 5 - Other Literary Genres", time: 9, unit: "Unit 2 - Literary Features")
english_a_level.topics.create!(name: "Topic 1 - Context of Production", time: 5, unit: "Unit 3: A Streetcar Named Desire")
english_a_level.topics.create!(name: "Topic 2 - Exposition Scenes", time: 7, unit: "Unit 3: A Streetcar Named Desire")
english_a_level.topics.create!(name: "Topic 3 - The Rising Action", time: 7, unit: "Unit 3: A Streetcar Named Desire")
english_a_level.topics.create!(name: "Topic 4 - Climax and Resolution", time: 6, unit: "Unit 3: A Streetcar Named Desire")
english_a_level.topics.create!(name: "Topic 5 - Application of Knowledge", time: 11, unit: "Unit 3: A Streetcar Named Desire")
english_a_level.topics.create!(name: "Topic 1 - Life Writing", time: 8, unit: "Unit 4. Genre Features (With synthesis of Topic 1 & 2)")
english_a_level.topics.create!(name: "Topic 2 - Travel Writing & Reviews", time: 7, unit: "Unit 4. Genre Features (With synthesis of Topic 1 & 2)")
english_a_level.topics.create!(name: "Topic 3 - Articles", time: 5, unit: "Unit 4. Genre Features (With synthesis of Topic 1 & 2)")
english_a_level.topics.create!(name: "Topic 4 - Interview & Podcast", time: 5, unit: "Unit 4. Genre Features (With synthesis of Topic 1 & 2)")
english_a_level.topics.create!(name: "Topic 5 - Writing for the Screen, Stage, Radio & Speeches", time: 11, unit: "Unit 4. Genre Features (With synthesis of Topic 1 & 2)")
english_a_level.topics.create!(name: "Topic 5.1 NEA Proposal", time: 10, unit: "Unit 5: Non-examined Assessment")
english_a_level.topics.create!(name: "Formal Coursework Proposal", time: 5, unit: "Unit 5: Non-examined Assessment")
english_a_level.topics.create!(name: "Topic 5.2 Reading and Research", time: 5, unit: "Unit 5: Non-examined Assessment")
english_a_level.topics.create!(name: "1st Draft Fiction Piece", time: 10, unit: "Unit 5: Non-examined Assessment")
english_a_level.topics.create!(name: "1st Draft Non-Fiction Piece", time: 10, unit: "Unit 5: Non-examined Assessment")
english_a_level.topics.create!(name: "1st Completed Portfolio", time: 15, unit: "Unit 5: Non-examined Assessment")
english_a_level.topics.create!(name: "Reading Log Submission", time: 10, unit: "Unit 5: Non-examined Assessment")
english_a_level.topics.create!(name: "Topic 1 - Cultural Context of Production", time: 10, unit: "Unit 6: A Room with a View")
english_a_level.topics.create!(name: "Topic 2 - Exposition & Rising Action", time: 9, unit: "Unit 6: A Room with a View")
english_a_level.topics.create!(name: "Topic 3 - Falling Action + Resolution", time: 8, unit: "Unit 6: A Room with a View")
english_a_level.topics.create!(name: "Topic 4 - Setting, characters & themes", time: 10, unit: "Unit 6: A Room with a View")
english_a_level.topics.create!(name: "Topic 5 - How to revise for Forster", time: 4, unit: "Unit 6: A Room with a View")
english_a_level.topics.create!(name: "Topic 1: Context of Production", time: 7, unit: "Unit 7: The Bloody Chamber")
english_a_level.topics.create!(name: "Topic 2: The Bloody Chamber & The Feline Stories", time: 10, unit: "Unit 7: The Bloody Chamber")
english_a_level.topics.create!(name: "Topic 3: Fantasy Stories", time: 3, unit: "Unit 7: The Bloody Chamber")
english_a_level.topics.create!(name: "Topic 4: Wolf Stories", time: 8, unit: "Unit 7: The Bloody Chamber")
english_a_level.topics.create!(name: "Topic 5: Check your knowledge of the whole text", time: 4, unit: "Unit 7: The Bloody Chamber")
english_a_level.topics.create!(name: "Topic 1: Paragraphing", time: 3, unit: "Unit 8: Exam Preparation")
english_a_level.topics.create!(name: "Topic 2: How to annotate", time: 3, unit: "Unit 8: Exam Preparation")
english_a_level.topics.create!(name: "Topic 3: How to analyse", time: 3, unit: "Unit 8: Exam Preparation")
english_a_level.topics.create!(name: "Topic 4: Comparative analysis Paper 1", time: 3, unit: "Unit 8: Exam Preparation")
english_a_level.topics.create!(name: "Topic 5: Comparative analysis Paper 2", time: 3, unit: "Unit 8: Exam Preparation")
english_a_level.topics.create!(name: "Mock 100%", time: 3, unit: "Mock 100%", milestone: true, has_grade: true)

xico = User.create!(
  email: "francisco-abf@hotmail.com",
  password: "123456",
  full_name: "Francisco Figueiredo",
  role: "admin"
  )

  brito = User.create!(
  email: "britoefaro@gmail.com",
  password: "123456",
  full_name: "Luis Brito e Faro",
  role: "admin"
  )

  tester = User.create!(
    email: "tester@tester.com",
    password: "123456",
    full_name: "Bug Catcher",
    role: "admin"
    )

  guest_lc = User.create!(
    email: "guest@lc.com",
    password: "123456",
    full_name: "Guest LC",
    role: "lc"
    )

joe = User.create!(
  email: "john@learner.com",
  password: "123456",
  full_name: "Joe King",
  role: "learner"
  )

mary = User.create!(
  email: "mary@learner.com",
  password: "123456",
  full_name: "Mary Queen",
  role: "learner"
  )

manel = User.create!(
  email: "manel@learner.com",
  password: "123456",
  full_name: "Manel Costa",
  role: "learner"
  )

quim = User.create!(
  email: "quim@learner.com",
  password: "123456",
  full_name: "Quim Barreiros",
  role: "learner"
  )


  porto = Hub.create!(
    name: "porto",
    country: "Portugal"
    )

  cascais = Hub.create!(
    name: "Cascais",
    country: "Portugal"
    )

  guest_lc  = UsersHub.create!(
    user: guest_lc,
    hub: cascais
  )

    xico_hub = UsersHub.create!(
      user: xico,
      hub: cascais
      )
    brito_hub = UsersHub.create!(
      user: brito,
      hub: cascais
    )

      joe_hub = UsersHub.create!(
        user: joe,
        hub: porto
        )

      manel_hub = UsersHub.create!(
      user: manel,
      hub: porto
      )

      mary_hub = UsersHub.create!(
      user: mary,
      hub: cascais
      )

      quim_hub = UsersHub.create!(
      user: quim,
      hub: cascais
      )


     Question.create!(
        value: "How well did you do,
          last week?",
        kda: true,
        sprint: false
      )

     Question.create!(
        value: "Why did you give yourself that rating? Provide two arguments.",
        kda: true,
        sprint: false
      )

      Question.create!(
        value: "How will you improve in each KDA, during this week? Give two strategies.",
        kda: true,
        sprint: false
      )

     Question.create!(
        value: " sprint question 1?",
        sprint: true,
        kda: false
      )

      Question.create!(
        value: " sprint question 2?",
        sprint: true,
        kda: false
      )

      Question.create!(
        value: " sprint question 3?",
        sprint: true,
        kda: false
      )

      Question.create!(
        value: " sprint question 4?",
        sprint: true,
        kda: false
      )

      Question.create!(
        value: " sprint question 5?",
        sprint: true,
        kda: false
      )

      Question.create!(
        value: " sprint question 6?",
        sprint: true,
        kda: false
      )


      Week.create!(
        name: "Week 8",
        start_date: "04/03/2024",
        end_date: "11/03/2024"
      )
      Week.create!(
        name: "Week 9",
        start_date: "11/03/2024",
        end_date: "18/03/2024"
      )
      Week.create!(
        name: "Week 10",
        start_date: "18/03/2024",
        end_date: "25/03/2024"
      )

      Week.create!(
        name: "Week 11",
        start_date: "01/04/2024",
        end_date: "08/04/2024"
      )

      Week.create!(
        name: "Week 12",
        start_date: "08/04/2024",
        end_date: "15/04/2024"
      )

      Week.create!(
        name: "Week 13",
        start_date: "15/04/2024",
        end_date: "22/04/2024"
      )
      Week.create!(
        name: "Week 14",
        start_date: "22/04/2024",
        end_date: "29/04/2024"
      )
      Week.create!(
        name: "Week 15",
        start_date: "29/04/2024",
        end_date: "06/05/2024"
      )
