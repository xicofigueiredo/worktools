# db/seeds.rb

# Define the subjects for each category along with exam dates
# db/seeds.rb
ActiveRecord::Base.transaction do
  # Other seeding logic here, ensuring uniqueness where necessary

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
  math_a_level.topics.create!(name: "Pure Mathematics MOCK - Paper 1,2,3,4", time: 7, milestone: true, has_grade: true, Mock50: true)
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
  math_a_level.topics.create!(name: "Warm up mock", time: 3, milestone: true, has_grade: true, Mock100: true)
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
chemistry_a_level.topics.create!(name: "Mock 50%", time: 3, milestone: true, has_grade: true, Mock50: true)
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
chemistry_a_level.topics.create!(name: "Mock 100%", time: 3, milestone: true, has_grade: true, Mock100: true)

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
  physics_a_level.topics.create!(name: "Mock 50%", time: 3, milestone: true, has_grade: true, Mock50: true)
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
  physics_a_level.topics.create!(name: "Mock 100%", time: 3, milestone: true, has_grade: true, Mock100: true)


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
  biology_a_level.topics.create!(name: "50% Mock Exam", time: 2, unit: "Unit 3: Practical Skills in Biology I", milestone: true, has_grade: true, Mock50: true)
  biology_a_level.topics.create!(name: "Unit 4: Energy, Environment, Microbiology and Immunity", time: 5, unit: "Unit 4: Energy, Environment, Microbiology and Immunity")
  biology_a_level.topics.create!(name: "Topic 5: Energy Flow, Ecosystems and the Environment", time: 35, unit: "Unit 4: Energy, Environment, Microbiology and Immunity")
  biology_a_level.topics.create!(name: "Topic 6: Microbiology, Immunity and Forensics", time: 35, unit: "Unit 4: Energy, Environment, Microbiology and Immunity")
  biology_a_level.topics.create!(name: "Unit 5: Respiration, Internal Environment, Coordination and Gene Technology", time: 5, unit: "Unit 5: Respiration, Internal Environment, Coordination and Gene Technology")
  biology_a_level.topics.create!(name: "Topic 7: Respiration, Muscles and the Internal Environment", time: 35, unit: "Unit 5: Respiration, Internal Environment, Coordination and Gene Technology")
  biology_a_level.topics.create!(name: "Topic 8: Coordination, Response and Gene Technology", time: 35, unit: "Unit 5: Respiration, Internal Environment, Coordination and Gene Technology")
  biology_a_level.topics.create!(name: "Unit 6: Practical Skills in Biology II", time: 5, unit: "Unit 6: Practical Skills in Biology II")
  biology_a_level.topics.create!(name: "Course Recap and Summaries", time: 5, unit: "Unit 6: Practical Skills in Biology II")
  biology_a_level.topics.create!(name: "100% Mock Exam Preparation", time: 10, unit: "Unit 6: Practical Skills in Biology II")
  biology_a_level.topics.create!(name: "100% Mock Exam", time: 2, unit: "Unit 6: Practical Skills in Biology II", milestone: true, has_grade: true, Mock100: true)


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
  business_a_level.topics.create!(name: "50% Mock Exam", time: 2, unit: "Unit 2: Managing Business Activities", milestone: true, has_grade: true, Mock50: true)
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
  business_a_level.topics.create!(name: "100% Mock Exam", time: 2, unit: "Unit 4: Global Business", milestone: true, has_grade: true, Mock100: true)


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
  economics_a_level.topics.create!(name: "Mock Exam 50%", time: 2, unit: "Unit 2 - Macroeconomic Performance And Policiy", milestone: true, has_grade: true, Mock50: true)
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
  economics_a_level.topics.create!(name: "Mock Exam 100%", time: 2, unit: "Unit 4  - Developments in the Global Economy", milestone: true, has_grade: true, Mock100: true)


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
    psychology_a_level.topics.create!(name: "50% Mock Exam", time: 3.5, unit: "Unit 2: Biological Psychology, Learning theories & Development", milestone: true, has_grade: true, Mock50: true)
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
    psychology_a_level.topics.create!(name: "100% Mock Exam", time: 8, unit: "Unit 4: Clinical Psychology & Psychological Skills", milestone: true, has_grade: true, Mock100: true)

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
  sociology_a_level.topics.create!(name: "50% Mock Exam", time: 3, unit: "50% Mock Exam", milestone: true, has_grade: true, Mock50: true)
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
  sociology_a_level.topics.create!(name: "100% Mock Exam", time: 3, unit: "100% Mock Exam", milestone: true, has_grade: true, Mock100: true)

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
  history_a_level.topics.create!(name: "50% Mock Exam  (Comprising of Units 1 and 2)", time: 2, unit: "50% Mock Exam  (Comprising of Units 1 and 2)", milestone: true, has_grade: true, Mock50: true)
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
  history_a_level.topics.create!(name: "100% Mock Exam  - Comprising of Units 3 and 4", time: 2, unit: "100% Mock Exam  - Comprising of Units 3 and 4", milestone: true, has_grade: true, Mock100: true)


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
geography_a_level.topics.create!(name: "Mock 50%", time: 3, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
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
geography_a_level.topics.create!(name: "Mock 100%", time: 3, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

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
english_a_level.topics.create!(name: "Mock 100%", time: 3, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

maths_igcse = Subject.create!(
  name: "Mathematics IGCSE",
  category: :igcse,
  )

  maths_igcse.topics.create!(name: "Introduction", time: 1, unit: "Introduction")
  maths_igcse.topics.create!(name: "Topic 1.1: Integers", time: 2.5, unit: "Unit 1: Numbers")
  maths_igcse.topics.create!(name: "Topic 1.2: Basic Arithmetic", time: 2.5, unit: "Unit 1: Numbers")
  maths_igcse.topics.create!(name: "Topic 1.3: Decimals", time: 3, unit: "Unit 1: Numbers")
  maths_igcse.topics.create!(name: "Topic 1.4: Fractions", time: 5, unit: "Unit 1: Numbers")
  maths_igcse.topics.create!(name: "Topic 1.5: Powers and Roots", time: 6, unit: "Unit 1: Numbers")
  maths_igcse.topics.create!(name: "Topic 1.6: Finding HCF and LCM", time: 5, unit: "Unit 1: Numbers")
  maths_igcse.topics.create!(name: "Topic 1.7: Set Notation", time: 6, unit: "Unit 1: Numbers")
  maths_igcse.topics.create!(name: "Topic 1.8: Percentages", time: 8, unit: "Unit 1: Numbers")
  maths_igcse.topics.create!(name: "Topic 1.9: Ratio and Proportion", time: 5, unit: "Unit 1: Numbers")
  maths_igcse.topics.create!(name: "Topic 1.10: Degrees of Accuracy", time: 4, unit: "Unit 1: Numbers")
  maths_igcse.topics.create!(name: "Topic 1.11: Standard Form", time: 4, unit: "Unit 1: Numbers")
  maths_igcse.topics.create!(name: "Cross-Topic Review (Unit 1 Numbers)", time: 13, unit: "Unit 1: Numbers")
  maths_igcse.topics.create!(name: "Master Assessments", time: 3, unit: "Unit 1: Numbers", milestone: true, has_grade: true)
  maths_igcse.topics.create!(name: "Topic 2.1: Electronic Calculators", time: 3, unit: "Unit 2: Algebra")
  maths_igcse.topics.create!(name: "Topic 2.2: Equations Formula and Identities", time: 3, unit: "Unit 2: Algebra")
  maths_igcse.topics.create!(name: "Topic 2.3: Rearranging Expressions and Formulae", time: 5, unit: "Unit 2: Algebra")
  maths_igcse.topics.create!(name: "Topic 2.4: Algebraic Manipulation", time: 6, unit: "Unit 2: Algebra")
  maths_igcse.topics.create!(name: "Topic 2.5: Algebraic Methods", time: 7, unit: "Unit 2: Algebra")
  maths_igcse.topics.create!(name: "Topic 2.6: Linear Equations", time: 6, unit: "Unit 2: Algebra")
  maths_igcse.topics.create!(name: "Topic 2.7: Graphs", time: 17, unit: "Unit 2: Algebra")
  maths_igcse.topics.create!(name: "Topic 2.8: Proportion", time: 4, unit: "Unit 2: Algebra")
  maths_igcse.topics.create!(name: "Topic 2.9: Simultaneous Equations", time: 7, unit: "Unit 2: Algebra")
  maths_igcse.topics.create!(name: "Topic 2.10: Quadratic Equations", time: 14, unit: "Unit 2: Algebra")
  maths_igcse.topics.create!(name: "Topic 2.11: Inequalities", time: 5, unit: "Unit 2: Algebra")
  maths_igcse.topics.create!(name: "Topic 2.12: Function Notation", time: 14, unit: "Unit 2: Algebra")
  maths_igcse.topics.create!(name: "Topic 2.13: Sequences", time: 6, unit: "Unit 2: Algebra")
  maths_igcse.topics.create!(name: "Topic 2.14: Further Graphs", time: 11, unit: "Unit 2: Algebra")
  maths_igcse.topics.create!(name: "Topic 2.15: Calculus", time: 15, unit: "Unit 2: Algebra")
  maths_igcse.topics.create!(name: "Cross-Topic Review (Unit 2 Algebra)", time: 15, unit: "Unit 2: Algebra")
  maths_igcse.topics.create!(name: "Master Assessments", time: 3, unit: "Unit 2: Algebra", milestone: true, has_grade: true)
  maths_igcse.topics.create!(name: "Mock Exam 50%", time: 2, unit: "Mock Exam 50%", milestone: true, has_grade: true, Mock50: true)
  maths_igcse.topics.create!(name: "Topic 3.1: Angles and Lines", time: 4, unit: "Unit 3: Geometry")
  maths_igcse.topics.create!(name: "Topic 3.2: Polygons and Triangles", time: 4, unit: "Unit 3: Geometry")
  maths_igcse.topics.create!(name: "Topic 3.3: Symmetry", time: 4, unit: "Unit 3: Geometry")
  maths_igcse.topics.create!(name: "Topic 3.4: Time and Measurements", time: 4, unit: "Unit 3: Geometry")
  maths_igcse.topics.create!(name: "Topic 3.5: Circles", time: 7, unit: "Unit 3: Geometry")
  maths_igcse.topics.create!(name: "Topic 3.6: Pythagoras Trigonometry", time: 6, unit: "Unit 3: Geometry")
  maths_igcse.topics.create!(name: "Topic 3.7: 3D Shapes Volume", time: 7, unit: "Unit 3: Geometry")
  maths_igcse.topics.create!(name: "Topic 3.8: Congruency and Similar Shapes", time: 6, unit: "Unit 3: Geometry")
  maths_igcse.topics.create!(name: "Topic 3.9: Perimeter Area Mensuration", time: 7, unit: "Unit 3: Geometry")
  maths_igcse.topics.create!(name: "Topic 3.10: Transformational Geometry", time: 5, unit: "Unit 3: Geometry")
  maths_igcse.topics.create!(name: "Topic 3.11: Vectors", time: 6, unit: "Unit 3: Geometry")
  maths_igcse.topics.create!(name: "Topic 3.12: Further Trigonometry", time: 8, unit: "Unit 3: Geometry")
  maths_igcse.topics.create!(name: "Cross-Topic (Unit 3 Geometry)", time: 14, unit: "Unit 3: Geometry")
  maths_igcse.topics.create!(name: "Master Assessments", time: 3, unit: "Unit 3: Geometry", milestone: true, has_grade: true)
  maths_igcse.topics.create!(name: "Unit 4: Statistics and Probability", time: 20, unit: "Unit 4: Statistics and Probability")
  maths_igcse.topics.create!(name: "Mock 100%", time: 2, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

  chemistry_igcse = Subject.create!(
    name: "Chemistry IGCSE",
    category: :igcse,
    )

chemistry_igcse.topics.create!(name: "Unit 0: Lab", time: 1, unit: "Unit 0: Lab")
chemistry_igcse.topics.create!(name: "Unit 0: Data Analysis", time: 1, unit: "Unit 0: Data Analysis")
chemistry_igcse.topics.create!(name: "1.1 States of Matter", time: 4, unit: "Unit 1: Principles of Chemistry")
chemistry_igcse.topics.create!(name: "1.2 Elements, Compounds and Mixtures", time: 4, unit: "Unit 1: Principles of Chemistry")
chemistry_igcse.topics.create!(name: "1.3 Atoms and Elements", time: 4, unit: "Unit 1: Principles of Chemistry")
chemistry_igcse.topics.create!(name: "1.4 Bonding", time: 10, unit: "Unit 1: Principles of Chemistry")
chemistry_igcse.topics.create!(name: "1.5 Chemical formulae, equations and calculations", time: 6, unit: "Unit 1: Principles of Chemistry")
chemistry_igcse.topics.create!(name: "1.6 Moles", time: 7, unit: "Unit 1: Principles of Chemistry")
chemistry_igcse.topics.create!(name: "Warm-Up Mock, Unit 1", time: 5, unit: "Unit 1: Principles of Chemistry", milestone: true, has_grade: true)
chemistry_igcse.topics.create!(name: "2.1 Group Chemistry", time: 5, unit: "Unit 2: Inorganic Chemistry")
chemistry_igcse.topics.create!(name: "2.2 Gases in the Atmosphere", time: 5, unit: "Unit 2: Inorganic Chemistry")
chemistry_igcse.topics.create!(name: "2.3 Reactivity Series", time: 9, unit: "Unit 2: Inorganic Chemistry")
chemistry_igcse.topics.create!(name: "2.4 Electrolysis", time: 6, unit: "Unit 2: Inorganic Chemistry")
chemistry_igcse.topics.create!(name: "2.5: Extraction and Uses of Metal", time: 4, unit: "Unit 2: Inorganic Chemistry")
chemistry_igcse.topics.create!(name: "2.6 Acids and Bases", time: 12, unit: "Unit 2: Inorganic Chemistry")
chemistry_igcse.topics.create!(name: "2.7 Chemical Tests", time: 13, unit: "Unit 2: Inorganic Chemistry")
chemistry_igcse.topics.create!(name: "Warm-Up Mock, Unit 2", time: 5, unit: "Unit 2: Inorganic Chemistry", milestone: true, has_grade: true)
chemistry_igcse.topics.create!(name: "50% Mock Exam", time: 2, unit: "50% Mock Exam", milestone: true, has_grade: true, Mock50: true)
chemistry_igcse.topics.create!(name: "3.1: Energetics", time: 6, unit: "Unit 3: Physical Chemistry")
chemistry_igcse.topics.create!(name: "3.2 Rates of Reaction", time: 8, unit: "Unit 3: Physical Chemistry")
chemistry_igcse.topics.create!(name: "3.3: Reversible Reactions and Equilibria", time: 8, unit: "Unit 3: Physical Chemistry")
chemistry_igcse.topics.create!(name: "Warm-Up Mock, Unit 3", time: 5, unit: "Unit 3: Physical Chemistry", milestone: true, has_grade: true)
chemistry_igcse.topics.create!(name: "4.1 Introduction", time: 4, unit: "Unit 4: Organic Chemistry")
chemistry_igcse.topics.create!(name: "4.2 Alkanes", time: 2, unit: "Unit 4: Organic Chemistry")
chemistry_igcse.topics.create!(name: "4.3: Alkenes", time: 2, unit: "Unit 4: Organic Chemistry")
chemistry_igcse.topics.create!(name: "4.4 Crude Oil", time: 6, unit: "Unit 4: Organic Chemistry")
chemistry_igcse.topics.create!(name: "4.5 Alcohols", time: 3, unit: "Unit 4: Organic Chemistry")
chemistry_igcse.topics.create!(name: "4.6 Carboxylic Acids", time: 2, unit: "Unit 4: Organic Chemistry")
chemistry_igcse.topics.create!(name: "4.7 Synthetic Polymers", time: 3, unit: "Unit 4: Organic Chemistry")
chemistry_igcse.topics.create!(name: "Warm-Up Mock, Unit 4", time: 2, unit: "Unit 4: Organic Chemistry", milestone: true, has_grade: true)
chemistry_igcse.topics.create!(name: "Exam Preparation", time: 19, unit: "Exam Preparation")
chemistry_igcse.topics.create!(name: "100% Mock Exam", time: 2, unit: "100% Mock", milestone: true, has_grade: true, Mock100: true)

  physics_igcse = Subject.create!(
    name: "Physics IGCSE",
    category: :igcse,
    )

    physics_igcse.topics.create!(name: "Topic 1.1 - Movement, Position & Velocity", time: 6, unit: "Unit 1 - Movement and Forces")
    physics_igcse.topics.create!(name: "Topic 1.2 - Forces", time: 6, unit: "Unit 1 - Movement and Forces")
    physics_igcse.topics.create!(name: "Topic 1.3 - Forces of Stopping Distances of Vehicles", time: 3, unit: "Unit 1 - Movement and Forces")
    physics_igcse.topics.create!(name: "Topic 1.4 - Falling Objects", time: 3, unit: "Unit 1 - Movement and Forces")
    physics_igcse.topics.create!(name: "Topic 1.5 - Extension and Hooke’s Law", time: 6, unit: "Unit 1 - Movement and Forces")
    physics_igcse.topics.create!(name: "Topic 1.6 - Momentum", time: 7, unit: "Unit 1 - Movement and Forces")
    physics_igcse.topics.create!(name: "Topic 1.7 - Moments", time: 7, unit: "Unit 1 - Movement and Forces")
    physics_igcse.topics.create!(name: "Topic 2.1 - Properties of Waves", time: 5, unit: "Unit 2 - Waves")
    physics_igcse.topics.create!(name: "Topic 2.2 - The Electromagnetic Spectrum", time: 5, unit: "Unit 2 - Waves")
    physics_igcse.topics.create!(name: "Topic 2.3 - Light", time: 8, unit: "Unit 2 - Waves")
    physics_igcse.topics.create!(name: "Topic 2.4 - Sound", time: 7, unit: "Unit 2 - Waves")
    physics_igcse.topics.create!(name: "Topic 3.1 - Density and Pressure", time: 5, unit: "Unit 3 - Solids, Liquids, and Gases")
    physics_igcse.topics.create!(name: "Topic 3.2 - Change of State", time: 5, unit: "Unit 3 - Solids, Liquids, and Gases")
    physics_igcse.topics.create!(name: "Topic 3.3 - Ideal Gases", time: 8, unit: "Unit 3 - Solids, Liquids, and Gases")
    physics_igcse.topics.create!(name: "Topic 4.1 - Energy Transfers and Stores", time: 4, unit: "Unit 4 - Energy Resources and Energy Transfers")
    physics_igcse.topics.create!(name: "Topic 4.2 - Energy Transfers - Heat", time: 5, unit: "Unit 4 - Energy Resources and Energy Transfers")
    physics_igcse.topics.create!(name: "Topic 4.3 - Work and Power", time: 5, unit: "Unit 4 - Energy Resources and Energy Transfers")
    physics_igcse.topics.create!(name: "Topic 4.4 - Energy Resources and Electricity Generation", time: 9, unit: "Unit 4 - Energy Resources and Energy Transfers")
    physics_igcse.topics.create!(name: "Mock 50%", time: 2, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
    physics_igcse.topics.create!(name: "Topic 5.1 - Electrical Current, Potential Difference and Resistance", time: 4, unit: "Unit 5 - Electricity")
    physics_igcse.topics.create!(name: "Topic 5.2 - Circuit Components - Series and Parallel Circuits", time: 7, unit: "Unit 5 - Electricity")
    physics_igcse.topics.create!(name: "Topic 5.3 - Mains Electricity and Electrical Power", time: 4, unit: "Unit 5 - Electricity")
    physics_igcse.topics.create!(name: "Topic 5.4 - Static Electricity", time: 7, unit: "Unit 5 - Electricity")
    physics_igcse.topics.create!(name: "Topic 6.1 - Magnetism", time: 5, unit: "Unit 6 - Magnetism and Electromagnetism")
    physics_igcse.topics.create!(name: "Topic 6.2 - Electromagnetism", time: 5, unit: "Unit 6 - Magnetism and Electromagnetism")
    physics_igcse.topics.create!(name: "Topic 6.3 - Electromagnetic Induction", time: 9, unit: "Unit 6 - Magnetism and Electromagnetism")
    physics_igcse.topics.create!(name: "Topic 7.1 - Atomic Model", time: 4, unit: "Unit 7 - Radioactivity and Particles")
    physics_igcse.topics.create!(name: "Topic 7.2 - Radioactivity", time: 6, unit: "Unit 7 - Radioactivity and Particles")
    physics_igcse.topics.create!(name: "Topic 7.3 Fission and Fusion", time: 7, unit: "Unit 7 - Radioactivity and Particles")
    physics_igcse.topics.create!(name: "Topic 8.1 - Motion in the Universe", time: 5, unit: "Unit 8 - Astrophysics")
    physics_igcse.topics.create!(name: "Topic 8.2 - Stellar Evolution", time: 5, unit: "Unit 8 - Astrophysics")
    physics_igcse.topics.create!(name: "Topic 8.3 - Cosmology", time: 7, unit: "Unit 8 - Astrophysics")
    physics_igcse.topics.create!(name: "Getting Ready for Mock Stage 2", time: 2, unit: "Unit 8 - Astrophysics")
    physics_igcse.topics.create!(name: "Mock 100%", time: 2, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

  biology_igcse = Subject.create!(
    name: "Biology IGCSE",
    category: :igcse,
    )

    biology_igcse.topics.create!(name: "Topic 1.1 Nature and Variety of Living Organisms", time: 4, unit: "Unit 1: Characteristics and Classification of Living Organisms")
    biology_igcse.topics.create!(name: "Topic 1.2 Classification of Organisms", time: 4, unit: "Unit 1: Characteristics and Classification of Living Organisms")
    biology_igcse.topics.create!(name: "Topic 2.1 Levels of Organisation", time: 4, unit: "Unit 2: Organisation of the Organism")
    biology_igcse.topics.create!(name: "Topic 2.2 Cells, Cell Structures, Cell Differentiation and Stem Cells", time: 4, unit: "Unit 2: Organisation of the Organism")
    biology_igcse.topics.create!(name: "Topic 3.1 Biological Molecules", time: 4, unit: "Unit 3: Biological Molecules")
    biology_igcse.topics.create!(name: "Topic 4.1 Enzymes", time: 4, unit: "Unit 4: Enzymes")
    biology_igcse.topics.create!(name: "Topic 5.1 Movement of Substances In and Out of Cells", time: 4, unit: "Unit 5: Movement of Substances")
    biology_igcse.topics.create!(name: "Topic 6.1 Photosynthesis and Leaf Structure", time: 4, unit: "Unit 6: Plant Nutrition")
    biology_igcse.topics.create!(name: "Topic 7.1 Human Nutrition and the Digestive System", time: 4, unit: "Unit 7: Human Nutrition and the Digestive System")
    biology_igcse.topics.create!(name: "Topic 8.1 General Transport Introduction", time: 4, unit: "Unit 8: Transport in Plants")
    biology_igcse.topics.create!(name: "Topic 8.2 Transport in Plants", time: 4, unit: "Unit 8: Transport in Plants")
    biology_igcse.topics.create!(name: "Topic 9.1 Transport in Humans", time: 4, unit: "Unit 9: Transport in Humans")
    biology_igcse.topics.create!(name: "Topic 10.1 Diseases", time: 4, unit: "Unit 10: Diseases and Immunity")
    biology_igcse.topics.create!(name: "Topic 10.2 Immunity", time: 4, unit: "Unit 10: Diseases and Immunity")
    biology_igcse.topics.create!(name: "Topic 11.1 Gas Exchange in Humans", time: 4, unit: "Unit 11: Gas Exchange")
    biology_igcse.topics.create!(name: "Topic 11.2 Gas Exchange in Plants", time: 4, unit: "Unit 11: Gas Exchange")
    biology_igcse.topics.create!(name: "Topic 12.1 Aerobic and Anaerobic Respiration", time: 4, unit: "Unit 12: Respiration")
    biology_igcse.topics.create!(name: "Topic 13.1 Excretion", time: 4, unit: "Unit 13: Excretion")
    biology_igcse.topics.create!(name: "Topic 14.1 Homeostasis", time: 4, unit: "Unit 14: Coordination and Response")
    biology_igcse.topics.create!(name: "Topic 14.2 The Nervous System", time: 4, unit: "Unit 14: Coordination and Response")
    biology_igcse.topics.create!(name: "Topic 14.3 Sense Organs", time: 4, unit: "Unit 14: Coordination and Response")
    biology_igcse.topics.create!(name: "Topic 14.4 The Endocrine System", time: 4, unit: "Unit 14: Coordination and Response")
    biology_igcse.topics.create!(name: "Topic 14.5 Tropic Responses in Plants", time: 4, unit: "Unit 14: Coordination and Response")
    biology_igcse.topics.create!(name: "Topic 15.1 Drugs", time: 4, unit: "Unit 15: Drugs")
    biology_igcse.topics.create!(name: "Mock 50%", time: 2, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
    biology_igcse.topics.create!(name: "Topic 16.1 Sexual vs Asexual Reproduction", time: 4, unit: "Unit 16: Reproduction")
    biology_igcse.topics.create!(name: "Topic 16.2 Reproduction in Plants", time: 4, unit: "Unit 16: Reproduction")
    biology_igcse.topics.create!(name: "Topic 16.3 Reproduction in Humans", time: 4, unit: "Unit 16: Reproduction")
    biology_igcse.topics.create!(name: "Topic 17.1 Chromosomes, Genes and Protein Synthesis", time: 4, unit: "Unit 17: Inheritance")
    biology_igcse.topics.create!(name: "Topic 17.2 Mitosis and Meiosis", time: 4, unit: "Unit 17: Inheritance")
    biology_igcse.topics.create!(name: "Topic 17.3 Monohybrid Inheritance", time: 4, unit: "Unit 17: Inheritance")
    biology_igcse.topics.create!(name: "Topic 18.1 Variation and Adaptation", time: 4, unit: "Unit 18: Variation and Selection")
    biology_igcse.topics.create!(name: "Topic 18.2 Natural and Artificial Selection", time: 4, unit: "Unit 18: Variation and Selection")
    biology_igcse.topics.create!(name: "Topic 19.1 Energy Flow and Food Chains", time: 4, unit: "Unit 19: Organisms and Their Environment")
    biology_igcse.topics.create!(name: "Topic 19.2 Ecology and Populations", time: 4, unit: "Unit 19: Organisms and Their Environment")
    biology_igcse.topics.create!(name: "Topic 19.3 Cycles Within Ecosystems", time: 4, unit: "Unit 19: Organisms and Their Environment")
    biology_igcse.topics.create!(name: "Topic 20.1 Food Supply and Production", time: 4, unit: "Unit 20: Human Influences on the Environment")
    biology_igcse.topics.create!(name: "Topic 20.2 Habitat Destruction and Pollution", time: 4, unit: "Unit 20: Human Influences on the Environment")
    biology_igcse.topics.create!(name: "Topic 20.3 Conservation", time: 4, unit: "Unit 20: Human Influences on the Environment")
    biology_igcse.topics.create!(name: "Topic 21.1 Biotechnology", time: 4, unit: "Unit 21: Biotechnology and Genetic Modification")
    biology_igcse.topics.create!(name: "Topic 21.2 Genetic Modification", time: 4, unit: "Unit 21: Biotechnology and Genetic Modification")
    biology_igcse.topics.create!(name: "Topic 21.3 Cloning", time: 4, unit: "Unit 21: Biotechnology and Genetic Modification")
    biology_igcse.topics.create!(name: "Topic 22.1 Revision Quizzes", time: 4, unit: "Unit 22: Revision")
    biology_igcse.topics.create!(name: "Mock 100%", time: 2, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

business_igcse = Subject.create!(
  name: "Business IGCSE",
  category: :igcse,
  )

  business_igcse.topics.create!(name: "Business Objectives", time: 5, unit: "Unit 1: Business Activity and Influences on Business")
  business_igcse.topics.create!(name: "Types of Organisation", time: 5, unit: "Unit 1: Business Activity and Influences on Business")
  business_igcse.topics.create!(name: "Classification of Businesses", time: 6, unit: "Unit 1: Business Activity and Influences on Business")
  business_igcse.topics.create!(name: "Decisions on Location", time: 5, unit: "Unit 1: Business Activity and Influences on Business")
  business_igcse.topics.create!(name: "Business and the International Community", time: 4, unit: "Unit 1: Business Activity and Influences on Business")
  business_igcse.topics.create!(name: "Government Objectives and Policies", time: 5, unit: "Unit 1: Business Activity and Influences on Business")
  business_igcse.topics.create!(name: "External Factors", time: 6, unit: "Unit 1: Business Activity and Influences on Business")
  business_igcse.topics.create!(name: "What Makes a Business Successful?", time: 7, unit: "Unit 1: Business Activity and Influences on Business")
  business_igcse.topics.create!(name: "Unit 1 Assessment", time: 4, unit: "Unit 1: Business Activity and Influences on Business", milestone: true, has_grade: true)
  business_igcse.topics.create!(name: "Internal and External Communication", time: 5, unit: "Unit 2 People in Business")
  business_igcse.topics.create!(name: "Recruitment and Selection Process", time: 6, unit: "Unit 2 People in Business")
  business_igcse.topics.create!(name: "Training", time: 5, unit: "Unit 2 People in Business")
  business_igcse.topics.create!(name: "Motivation and Rewards", time: 6, unit: "Unit 2 People in Business")
  business_igcse.topics.create!(name: "Organisation Structure and Employees", time: 7, unit: "Unit 2 People in Business")
  business_igcse.topics.create!(name: "Unit 2 Assessment", time: 2, unit: "Unit 2 People in Business", milestone: true, has_grade: true)
  business_igcse.topics.create!(name: "Assessment Preparation and Support Materials
  ", time: 4, unit: "Assessment Preparation and Support Materials")
  business_igcse.topics.create!(name: "Mock 50%", time: 2, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
  business_igcse.topics.create!(name: "Business Finance Sources", time: 5, unit: "Unit 3 Business Finance")
  business_igcse.topics.create!(name: "Cash Flow Forecasting", time: 5, unit: "Unit 3 Business Finance")
  business_igcse.topics.create!(name: "Cost and Break-even Analysis", time: 6, unit: "Unit 3 Business Finance")
  business_igcse.topics.create!(name: "Financial Documents", time: 5, unit: "Unit 3 Business Finance")
  business_igcse.topics.create!(name: "Accounts Analysis", time: 5, unit: "Unit 3 Business Finance")
  business_igcse.topics.create!(name: "Unit 3 Assessment", time: 2, unit: "Unit 3 Business Finance", milestone: true, has_grade: true)
  business_igcse.topics.create!(name: "Market Research", time: 5, unit: "Unit 4 Marketing")
  business_igcse.topics.create!(name: "The Market", time: 6, unit: "Unit 4 Marketing")
  business_igcse.topics.create!(name: "The Marketing Mix", time: 5, unit: "Unit 4 Marketing")
  business_igcse.topics.create!(name: "Unit 4 Assessment", time: 2, unit: "Unit 4 Marketing", milestone: true, has_grade: true)
  business_igcse.topics.create!(name: "Economies and Diseconomies of Scale", time: 5, unit: "Unit 5 Business Operations")
  business_igcse.topics.create!(name: "Production", time: 6, unit: "Unit 5 Business Operations")
  business_igcse.topics.create!(name: "Factors of Production", time: 5, unit: "Unit 5 Business Operations")
  business_igcse.topics.create!(name: "Quality", time: 5, unit: "Unit 5 Business Operations")
  business_igcse.topics.create!(name: "Unit 5 Assessment", time: 2, unit: "Unit 5 Business Operations", milestone: true, has_grade: true)
  business_igcse.topics.create!(name: "Assessment Preparation and Support Materials
  ", time: 4, unit: "Assessment Preparation and Support Materials")
  business_igcse.topics.create!(name: "Mock 100%", time: 2, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

  portuguese_igcse = Subject.create!(
    name: "Portuguese IGCSE",
    category: :igcse,
    )

  portuguese_igcse.topics.create!(name: "Sugestões para te tornares um escritor conhecido+ um devorador de livros", time: 5, unit: "Unidade 0")
  portuguese_igcse.topics.create!(name: "Tópico 1.1: Conseguir-se-á definir VIAGEM? 🤔", time: 5, unit: "Unidade 1: A viagem")
  portuguese_igcse.topics.create!(name: "Tópico 1.2: Blogue de Viagem", time: 5, unit: "Unidade 1: A viagem")
  portuguese_igcse.topics.create!(name: "Tópico 1.3: O Vídeo e a Viagem", time: 9, unit: "Unidade 1: A viagem")
  portuguese_igcse.topics.create!(name: "Tópico 1.4: Relato de Viagem", time: 9, unit: "Unidade 1: A viagem")
  portuguese_igcse.topics.create!(name: "Tópico 1.5: Texto Informativo", time: 14, unit: "Unidade 1: A viagem")
  portuguese_igcse.topics.create!(name: "Tópico 1.6: A viagem na literatura", time: 12, unit: "Unidade 1: A viagem")
  portuguese_igcse.topics.create!(name: "Tópico 2.1: Elementos", time: 33, unit: "Unidade 2: A Presença da Natureza")
  portuguese_igcse.topics.create!(name: "Tópico 2.2: Catástrofes Naturais", time: 13, unit: "Unidade 2: A Presença da Natureza")
  portuguese_igcse.topics.create!(name: "Tópico 2.3: A Natureza no Nosso Cotidiano / Quotidiano", time: 11, unit: "Unidade 2: A Presença da Natureza")
  portuguese_igcse.topics.create!(name: "Tópico 3.1: Fixar normas da língua? Para quê?", time: 12, unit: "Unidade 3: Pontos de vista- A língua portuguesa")
  portuguese_igcse.topics.create!(name: "Tópico 3.2: O poder das palavras", time: 8, unit: "Unidade 3: Pontos de vista- A língua portuguesa")
  portuguese_igcse.topics.create!(name: "Tópico 4.1: Comunicação e solidão", time: 19, unit: "Unidade 4: Estamos todos num palco")
  portuguese_igcse.topics.create!(name: "Mock 50%", time: 2, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
  portuguese_igcse.topics.create!(name: "Tópico 5.1 - Eu e os Outros", time: 10, unit: "Unidade 5: Eu. Perdido entre a família e os amigos?")
  portuguese_igcse.topics.create!(name: "Tópico 5.2 - Eu", time: 11, unit: "Unidade 5: Eu. Perdido entre a família e os amigos?")
  portuguese_igcse.topics.create!(name: "Tópico 6.1 Fugas ao Mundo Material", time: 22, unit: "Unidade 6: Um mundo material")
  portuguese_igcse.topics.create!(name: "Tópico 6.2 - Presos num mundo material", time: 11, unit: "Unidade 6: Um mundo material")
  portuguese_igcse.topics.create!(name: "Tópico 7.1 Storytelling", time: 3, unit: "Unidade 7: Acredita ou não. Qual é a verdade?")
  portuguese_igcse.topics.create!(name: "Tópico 7.2 - Fakenews", time: 10, unit: "Unidade 7: Acredita ou não. Qual é a verdade?")
  portuguese_igcse.topics.create!(name: "Topico 8.1 - Famosos. Para quem?", time: 10, unit: "Unidade 8: Famosos. Para quem?")
  portuguese_igcse.topics.create!(name: "Tópico 9.1 -  O fim. Será?", time: 12, unit: "Unidade 9: O fim. Será?")
  portuguese_igcse.topics.create!(name: "Mock 100%", time: 2, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

spanish_igcse = Subject.create!(
  name: "Spanish IGCSE",
  category: :igcse,
  )

  spanish_igcse.topics.create!(name: "¿Quiénes somos?", time: 0, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Tomar conciencia de la identidad personal y cultural", time: 1.5, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Captar la idea general de un texto", time: 1, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Entender el vocabulario específico en un texto largo", time: 2, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Corregir la ortografía, la acentuación y la gramática de un texto", time: 1, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Escribir un texto con correcta ortografía, acentuación y gramática", time: 2, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Taller de escritura", time: 1, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Mundos de ficción", time: 0, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Predecir el contenido de un texto", time: 1.5, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Entender y utilizar connotaciones", time: 1, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Escribir un resumen", time: 2, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Taller de escritura", time: 2, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Mi vida en línea", time: 0, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Encontrar información específica en un texto", time: 1, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Formar una opinión sobre un texto informativo", time: 2, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Formar una opinión sobre un texto de ficción", time: 1, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Escribir mensajes informales", time: 2.5, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Escribir mensajes formales", time: 2, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Taller de escritura", time: 1, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Taller de escritura", time: 1, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "PORTAL de SUPERACIÓN", time: 3, unit: "Fase Uno: Mi entorno")
  spanish_igcse.topics.create!(name: "Tiempo de ocio", time: 0, unit: "Fase Dos: El tiempo libre")
  spanish_igcse.topics.create!(name: "Identificar causas y consecuencias", time: 1.5, unit: "Fase Dos: El tiempo libre")
  spanish_igcse.topics.create!(name: "Identificar una secuencia de eventos", time: 2, unit: "Fase Dos: El tiempo libre")
  spanish_igcse.topics.create!(name: "Escribir un artículo de opinión", time: 2, unit: "Fase Dos: El tiempo libre")
  spanish_igcse.topics.create!(name: "Taller de escritura", time: 1, unit: "Fase Dos: El tiempo libre")
  spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Dos: El tiempo libre")
  spanish_igcse.topics.create!(name: "Disfraces y máscaras", time: 0, unit: "Fase Dos: El tiempo libre")
  spanish_igcse.topics.create!(name: "Profundizar en las capacidades de paráfrasis y síntesis", time: 3.5, unit: "Fase Dos: El tiempo libre")
  spanish_igcse.topics.create!(name: "Taller de escritura", time: 3, unit: "Fase Dos: El tiempo libre")
  spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Dos: El tiempo libre")
  spanish_igcse.topics.create!(name: "De viaje por América", time: 0, unit: "Fase Dos: El tiempo libre")
  spanish_igcse.topics.create!(name: "Identificar los sentimientos del narrador protagonista y otros personajes", time: 1.5, unit: "Fase Dos: El tiempo libre")
  spanish_igcse.topics.create!(name: "Escribir un texto descriptivo", time: 1, unit: "Fase Dos: El tiempo libre")
  spanish_igcse.topics.create!(name: "Taller de escritura", time: 3, unit: "Fase Dos: El tiempo libre")
  spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Dos: El tiempo libre")
  spanish_igcse.topics.create!(name: "PORTAL de SUPERACIÓN", time: 3, unit: "Fase Dos: El tiempo libre")
  spanish_igcse.topics.create!(name: "Mock 50%", time: 2, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
  spanish_igcse.topics.create!(name: "El mundo que habitamos", time: 7.5, unit: "Fase Tres: El medio ambiente")
  spanish_igcse.topics.create!(name: "Taller de escritura", time: 1, unit: "Fase Tres: El medio ambiente")
  spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Tres: El medio ambiente")
  spanish_igcse.topics.create!(name: "Una vida sana", time: 4.5, unit: "Fase Tres: El medio ambiente")
  spanish_igcse.topics.create!(name: "Taller de escritura", time: 2, unit: "Fase Tres: El medio ambiente")
  spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Tres: El medio ambiente")
  spanish_igcse.topics.create!(name: "Usar y tirar", time: 8.5, unit: "Fase Tres: El medio ambiente")
  spanish_igcse.topics.create!(name: "Taller de escritura", time: 1, unit: "Fase Tres: El medio ambiente")
  spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Tres: El medio ambiente")
  spanish_igcse.topics.create!(name: "PORTAL de SUPERACIÓN", time: 3, unit: "Fase Tres: El medio ambiente")
  spanish_igcse.topics.create!(name: "FASE CUATRO: La sociedad", time: 0, unit: "Fase Cuatro: La sociedad")
  spanish_igcse.topics.create!(name: "El mundo laboral", time: 5.5, unit: "Fase Cuatro: La sociedad")
  spanish_igcse.topics.create!(name: "Taller de escritura", time: 1, unit: "Fase Cuatro: La sociedad")
  spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Cuatro: La sociedad")
  spanish_igcse.topics.create!(name: "En busca de una vida mejor", time: 3.5, unit: "Fase Cuatro: La sociedad")
  spanish_igcse.topics.create!(name: "Taller de escritura", time: 3, unit: "Fase Cuatro: La sociedad")
  spanish_igcse.topics.create!(name: "Punto de verificación", time: 2, unit: "Fase Cuatro: La sociedad")
  spanish_igcse.topics.create!(name: "Planes de futuro", time: 2.5, unit: "Fase Cuatro: La sociedad")
  spanish_igcse.topics.create!(name: "Punto de verificación", time: 3, unit: "Fase Cuatro: La sociedad")
  spanish_igcse.topics.create!(name: "Taller de escritura", time: 2, unit: "Fase Cuatro: La sociedad")
  spanish_igcse.topics.create!(name: "PORTAL de SUPERACIÓN", time: 3, unit: "Fase Cuatro: La sociedad")
  spanish_igcse.topics.create!(name: "Mock 100%", time: 2, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

sociology_igcse = Subject.create!(
  name: "Sociology IGCSE",
  category: :igcse,
  )

  sociology_igcse.topics.create!(name: "Topic 1.1 What is Sociology?", time: 6, unit: "Unit 1 Theory and Methods")
  sociology_igcse.topics.create!(name: "Topic 1.2 How do sociologists study society?", time: 6, unit: "Unit 1 Theory and Methods")
  sociology_igcse.topics.create!(name: "Topic 1.3 Sampling and sampling methods", time: 6, unit: "Unit 1 Theory and Methods")
  sociology_igcse.topics.create!(name: "Topic 1.4 Information and data", time: 6, unit: "Unit 1 Theory and Methods")
  sociology_igcse.topics.create!(name: "Topic 1.5 Evaluating Sociological Research", time: 10.5, unit: "Unit 1 Theory and Methods")
  sociology_igcse.topics.create!(name: "Topic 2.1 Individuals and Society", time: 5, unit: "Unit 2 Culture, identity and socialisation")
  sociology_igcse.topics.create!(name: "Topic 2.2 How do we learn to be human?", time: 9.5, unit: "Unit 2 Culture, identity and socialisation")
  sociology_igcse.topics.create!(name: "Topic 3.1 Wealth & Income and Ethnic Grouping", time: 6, unit: "Unit 3 Social Inequality")
  sociology_igcse.topics.create!(name: "Topic 3.2 Gender and Social Class", time: 11, unit: "Unit 3 Social Inequality")
  sociology_igcse.topics.create!(name: "Topic 3.3 What is social stratification?", time: 16.5, unit: "Unit 3 Social Inequality")
  sociology_igcse.topics.create!(name: "50% Mock Exam Practice", time: 4, unit: "Mock 50%", milestone: true, has_grade: true)
  sociology_igcse.topics.create!(name: "Mock 50%", time: 4, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
  sociology_igcse.topics.create!(name: "Topic 4.1 Why families?", time: 6, unit: "Unit 4 Families")
  sociology_igcse.topics.create!(name: "Topic 4.2 The functions of the family", time: 4, unit: "Unit 4 Families")
  sociology_igcse.topics.create!(name: "Topic 4.3 What are the main roles within the family?", time: 4, unit: "Unit 4 Families")
  sociology_igcse.topics.create!(name: "Topic 4.4 What changes are affecting the family?", time: 9.5, unit: "Unit 4 Families")
  sociology_igcse.topics.create!(name: "Topic 5.1 Introduction", time: 6, unit: "Unit 5 Education")
  sociology_igcse.topics.create!(name: "Topic 5.2 What is education?", time: 7, unit: "Unit 5 Education")
  sociology_igcse.topics.create!(name: "Topic 5.3 Differences in Educational Achievement", time: 9.5, unit: "Unit 5 Education")
  sociology_igcse.topics.create!(name: "Topic 6.1 Normal Behaviour and Deviance", time: 6, unit: "Unit 6 Crime, Deviance and Social Control")
  sociology_igcse.topics.create!(name: "Topic 6.2 Breaking Society’s Rules", time: 8.5, unit: "Unit 6 Crime, Deviance and Social Control")
  sociology_igcse.topics.create!(name: "Topic 7.1 What are the mass media?", time: 6, unit: "Unit 7 Media")
  sociology_igcse.topics.create!(name: "Topic 7.2 Media cultures", time: 6, unit: "Unit 7 Media")
  sociology_igcse.topics.create!(name: "Topic 7.3 Impact and Influence of the mass media", time: 9, unit: "Unit 7 Media")
  sociology_igcse.topics.create!(name: "Final Assessment", time: 1, unit: "Final Assessment", milestone: true, has_grade: true)
  sociology_igcse.topics.create!(name: "100% Mock Practice", time: 4, unit: "100% Mock Practice", milestone: true, has_grade: true)
  sociology_igcse.topics.create!(name: "Mock 100%", time: 4, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

  history_igcse = Subject.create!(
    name: "History IGCSE",
    category: :igcse,
    )

    history_igcse.topics.create!(name: "Topic 1: Reasons for the Cold War", time: 7, unit: "Unit 1: A World Divided: Superpower Relations (1943–72)")
    history_igcse.topics.create!(name: "Topic 2: Early Developments in the Cold War (1945-49)", time: 7, unit: "Unit 1: A World Divided: Superpower Relations (1943–72)")
    history_igcse.topics.create!(name: "Topic 3: The Cold War in the 1950s", time: 5, unit: "Unit 1: A World Divided: Superpower Relations (1943–72)")
    history_igcse.topics.create!(name: "Topic 4: Three Crises: Berlin, Cuba, and Czechoslovakia", time: 7, unit: "Unit 1: A World Divided: Superpower Relations (1943–72)")
    history_igcse.topics.create!(name: "Topic 5: The Thaw and Moves Toward Detente (1963-72)", time: 6.5, unit: "Unit 1: A World Divided: Superpower Relations (1943–72)")
    history_igcse.topics.create!(name: "Topic 1: The Red Scare and McCarthyism", time: 7, unit: "Unit 2: Depth Study: A Divided Union: Civil Rights in the USA (1945-74)")
    history_igcse.topics.create!(name: "Topic 2: Civil Rights in the 1950s", time: 7, unit: "Unit 2: Depth Study: A Divided Union: Civil Rights in the USA (1945-74)")
    history_igcse.topics.create!(name: "Topic 3: The Impact of Civil Rights Protests (1960-74)", time: 5, unit: "Unit 2: Depth Study: A Divided Union: Civil Rights in the USA (1945-74)")
    history_igcse.topics.create!(name: "Topic 4: Other Protest Movements: Students, Women, and Anti-Vietnam", time: 7, unit: "Unit 2: Depth Study: A Divided Union: Civil Rights in the USA (1945-74)")
    history_igcse.topics.create!(name: "Topic 5: Nixon and Watergate", time: 6.5, unit: "Unit 2: Depth Study: A Divided Union: Civil Rights in the USA (1945-74)")
    history_igcse.topics.create!(name: "Mock 50%", time: 1.5, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
    history_igcse.topics.create!(name: "Topic 1", time: 6, unit: "Unit 3: Historical Investigation: The Origins and Course of the First World War (1905-18)")
    history_igcse.topics.create!(name: "Topic 2", time: 5.5, unit: "Unit 3: Historical Investigation: The Origins and Course of the First World War (1905-18)")
    history_igcse.topics.create!(name: "Topic 3", time: 7, unit: "Unit 3: Historical Investigation: The Origins and Course of the First World War (1905-18)")
    history_igcse.topics.create!(name: "Topic 4", time: 7, unit: "Unit 3: Historical Investigation: The Origins and Course of the First World War (1905-18)")
    history_igcse.topics.create!(name: "Topic 5", time: 7, unit: "Unit 3: Historical Investigation: The Origins and Course of the First World War (1905-18)")
    history_igcse.topics.create!(name: "Topic 1 Progress in the Mid-19th Century", time: 5, unit: "Unit 4: Breadth Study in Change: Changes in Medicine (c.1848-1948)")
    history_igcse.topics.create!(name: "Topic 2", time: 5.5, unit: "Unit 4: Breadth Study in Change: Changes in Medicine (c.1848-1948)")
    history_igcse.topics.create!(name: "Topic 3 Accelerating Change (1875-1905)", time: 7, unit: "Unit 4: Breadth Study in Change: Changes in Medicine (c.1848-1948)")
    history_igcse.topics.create!(name: "Topic 4 Government Action and War (1905-20)-left off", time: 7, unit: "Unit 4: Breadth Study in Change: Changes in Medicine (c.1848-1948)")
    history_igcse.topics.create!(name: "Topic 5 Advances in Medicine, Surgery, and Public Health (1920-48)", time: 7, unit: "Unit 4: Breadth Study in Change: Changes in Medicine (c.1848-1948)")
    history_igcse.topics.create!(name: "Mock 100%", time: 1.5, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

    geography_igcse = Subject.create!(
      name: "Geography IGCSE",
      category: :igcse,
      )

geography_igcse.topics.create!(name: "Topic 1: Water on Earth", time: 2, unit: "Unit 1: River Environments")
geography_igcse.topics.create!(name: "Topic 2: River Regimes and Hydrographs", time: 2, unit: "Unit 1: River Environments")
geography_igcse.topics.create!(name: "Topic 3: River Process", time: 2, unit: "Unit 1: River Environments")
geography_igcse.topics.create!(name: "Topic 4: River Characteristics", time: 2, unit: "Unit 1: River Environments")
geography_igcse.topics.create!(name: "Topic 5: River Features", time: 2, unit: "Unit 1: River Environments")
geography_igcse.topics.create!(name: "Topic 6: Water Uses, Supply & Demand", time: 2, unit: "Unit 1: River Environments")
geography_igcse.topics.create!(name: "Topic 7: Water Quality & Management", time: 2, unit: "Unit 1: River Environments")
geography_igcse.topics.create!(name: "Topic 8: River Flooding", time: 2, unit: "Unit 1: River Environments")
geography_igcse.topics.create!(name: "Topic 9: Rivers & Fieldwork", time: 2, unit: "Unit 1: River Environments")
geography_igcse.topics.create!(name: "Unit 1 Assignments & Assessment", time: 4, unit: "Unit 1: River Environments", milestone: true, has_grade: true)
geography_igcse.topics.create!(name: "Topic 1: Coastal Processes", time: 2, unit: "Unit 2 Coastal Environments")
geography_igcse.topics.create!(name: "Topic 2: Factors Affecting Coasts", time: 2, unit: "Unit 2 Coastal Environments")
geography_igcse.topics.create!(name: "Topic 3: Coastal Landforms", time: 2, unit: "Unit 2 Coastal Environments")
geography_igcse.topics.create!(name: "Topic 4: Coastal Ecosystems", time: 2, unit: "Unit 2 Coastal Environments")
geography_igcse.topics.create!(name: "Topic 5: Threats Coastal Ecosystems", time: 2, unit: "Unit 2 Coastal Environments")
geography_igcse.topics.create!(name: "Topic 6: Coastal Conflicts", time: 2, unit: "Unit 2 Coastal Environments")
geography_igcse.topics.create!(name: "Topic 7: Coastal Flooding", time: 2, unit: "Unit 2 Coastal Environments")
geography_igcse.topics.create!(name: "Topic 8: Coastal Management", time: 2, unit: "Unit 2 Coastal Environments")
geography_igcse.topics.create!(name: "Topic 9: Coastal Fieldwork", time: 2, unit: "Unit 2 Coastal Environments")
geography_igcse.topics.create!(name: "Unit 2 Assignments & Assessment", time: 4, unit: "Unit 2 Coastal Environments", milestone: true, has_grade: true)
geography_igcse.topics.create!(name: "Topic 1 - Different Types of Hazard", time: 2, unit: "Unit 3 Hazardous Environments")
geography_igcse.topics.create!(name: "Topic 2 - Tropical Cyclones", time: 2, unit: "Unit 3 Hazardous Environments")
geography_igcse.topics.create!(name: "Topic 3 - Volcanic Eruptions and Earthquakes", time: 2, unit: "Unit 3 Hazardous Environments")
geography_igcse.topics.create!(name: "Topic 4 - The Scale of Tectonic Hazards", time: 2, unit: "Unit 3 Hazardous Environments")
geography_igcse.topics.create!(name: "Topic 5 - Impacts of Tectonic Hazards", time: 2, unit: "Unit 3 Hazardous Environments")
geography_igcse.topics.create!(name: "Topic 6 - Reasons for living in high-risk areas", time: 2, unit: "Unit 3 Hazardous Environments")
geography_igcse.topics.create!(name: "Topic 7 - Tropical cyclones and their impact", time: 2, unit: "Unit 3 Hazardous Environments")
geography_igcse.topics.create!(name: "Topic 8 - Predicting and preparing for earthquakes", time: 2, unit: "Unit 3 Hazardous Environments")
geography_igcse.topics.create!(name: "Topic 9 - Responding to hazards", time: 2, unit: "Unit 3 Hazardous Environments")
geography_igcse.topics.create!(name: "Unit 3 Assignments & Assessment", time: 4, unit: "Unit 3 Hazardous Environments", milestone: true, has_grade: true)
geography_igcse.topics.create!(name: "Mock 50%", time: 2, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
geography_igcse.topics.create!(name: "Topic 1: Economic Activity", time: 2, unit: "Unit 4 Economic Activity and Energy")
geography_igcse.topics.create!(name: "Topic 2: The Location of Industries", time: 2, unit: "Unit 4 Economic Activity and Energy")
geography_igcse.topics.create!(name: "Topic 3: The Changing Location of Industry", time: 2, unit: "Unit 4 Economic Activity and Energy")
geography_igcse.topics.create!(name: "Topic 4: Change in Economic Sectors", time: 2, unit: "Unit 4 Economic Activity and Energy")
geography_igcse.topics.create!(name: "Topic 5: Impact of Sector Shifts", time: 2, unit: "Unit 4 Economic Activity and Energy")
geography_igcse.topics.create!(name: "Topic 6: Informal Employment", time: 2, unit: "Unit 4 Economic Activity and Energy")
geography_igcse.topics.create!(name: "Topic 7: Population and Resources", time: 2, unit: "Unit 4 Economic Activity and Energy")
geography_igcse.topics.create!(name: "Topic 8: The Demand for Energy", time: 2, unit: "Unit 4 Economic Activity and Energy")
geography_igcse.topics.create!(name: "Topic 9: Energy Case Studies", time: 2, unit: "Unit 4 Economic Activity and Energy")
geography_igcse.topics.create!(name: "Unit 4 Assignments & Assessment", time: 4, unit: "Unit 4 Economic Activity and Energy", milestone: true, has_grade: true)
geography_igcse.topics.create!(name: "Topic 1: Biomes", time: 2, unit: "Unit 5 Ecosystems and Rural Environments")
geography_igcse.topics.create!(name: "Topic 2: People and Ecosystems", time: 2, unit: "Unit 5 Ecosystems and Rural Environments")
geography_igcse.topics.create!(name: "Topic 3: Rural Environments", time: 2, unit: "Unit 5 Ecosystems and Rural Environments")
geography_igcse.topics.create!(name: "Topic 4: Rural Change in the UK", time: 2, unit: "Unit 5 Ecosystems and Rural Environments")
geography_igcse.topics.create!(name: "Topic 5: Changing Rural Environments in India", time: 2, unit: "Unit 5 Ecosystems and Rural Environments")
geography_igcse.topics.create!(name: "Topic 6: Diversification", time: 2, unit: "Unit 5 Ecosystems and Rural Environments")
geography_igcse.topics.create!(name: "Topic 7: Rural Management", time: 2, unit: "Unit 5 Ecosystems and Rural Environments")
geography_igcse.topics.create!(name: "Topic 8: Urban Management", time: 4, unit: "Unit 5 Ecosystems and Rural Environments")
geography_igcse.topics.create!(name: "Unit 5 Assignments & Assessment", time: 4, unit: "Unit 5 Ecosystems and Rural Environments", milestone: true, has_grade: true)
geography_igcse.topics.create!(name: "Topic 1: Fragile Environments", time: 2, unit: "Unit 6 Fragile Environments")
geography_igcse.topics.create!(name: "Topic 2: Desertification", time: 2, unit: "Unit 6 Fragile Environments")
geography_igcse.topics.create!(name: "Topic 3: Deforestation", time: 2, unit: "Unit 6 Fragile Environments")
geography_igcse.topics.create!(name: "Topic 4: Global Warming and Climate Change", time: 2, unit: "Unit 6 Fragile Environments")
geography_igcse.topics.create!(name: "Unit 6 Assignments & Assessment", time: 4, unit: "Unit 6 Fragile Environments", milestone: true, has_grade: true)
geography_igcse.topics.create!(name: "Topic 1: Geographical Methods and Techniques", time: 2, unit: "Unit 7 Geographical Methods and Techniques")
geography_igcse.topics.create!(name: "Topic 2: FIELDWORK", time: 20, unit: "Unit 7 Geographical Methods and Techniques")
geography_igcse.topics.create!(name: "Mock 100%", time: 8, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)

tt_igse = Subject.create!(
  name: "Travel & Tourism IGCSE",
  category: :igcse,
  )

tt_igse.topics.create!(name: "Unit 0 - Introduction", time: 1, unit: "Introduction")
tt_igse.topics.create!(name: "Structure of international travel and tourism industry", time: 3, unit: "Unit 1 - The Travel and Tourism Industry")
tt_igse.topics.create!(name: "The economic, environmental and socio-cultural impact of travel and tourism", time: 5, unit: "Unit 1 - The Travel and Tourism Industry")
tt_igse.topics.create!(name: "Role of national governments in forming tourism policy and promotion", time: 3, unit: "Unit 1 - The Travel and Tourism Industry")
tt_igse.topics.create!(name: "The pattern of demand for international travel and tourism", time: 3, unit: "Unit 1 - The Travel and Tourism Industry")
tt_igse.topics.create!(name: "Final Assessments", time: 4, unit: "Unit 1 - The Travel and Tourism Industry", milestone: true, has_grade: true)
tt_igse.topics.create!(name: "The main global features", time: 4, unit: "Unit 2 - Features of worldwide destinations")
tt_igse.topics.create!(name: "Different Time zones and climates", time: 3, unit: "Unit 2 - Features of worldwide destinations")
tt_igse.topics.create!(name: "Investigate travel and tourism destinations", time: 3, unit: "Unit 2 - Features of worldwide destinations")
tt_igse.topics.create!(name: "The features which attract tourists to a particular destination", time: 3, unit: "Unit 2 - Features of worldwide destinations")
tt_igse.topics.create!(name: "Final Assessments", time: 6, unit: "Unit 2 - Features of worldwide destinations", milestone: true, has_grade: true)
tt_igse.topics.create!(name: "Deal with customers and colleagues", time: 5, unit: "Unit 3 - Customer care and working procedures")
tt_igse.topics.create!(name: "Identify the essential personal skills required when working in the travel and tourism industry", time: 4, unit: "Unit 3 - Customer care and working procedures")
tt_igse.topics.create!(name: "Follow basic procedures when handling customer enquiries, reservations and payments", time: 4, unit: "Unit 3 - Customer care and working procedures")
tt_igse.topics.create!(name: "Use reference sources to obtain information", time: 4, unit: "Unit 3 - Customer care and working procedures")
tt_igse.topics.create!(name: "Explore the presentation and promotion of tourist facilities", time: 4, unit: "Unit 3 - Customer care and working procedures")
tt_igse.topics.create!(name: "Final Assessments", time: 6, unit: "Unit 3 - Customer care and working procedures", milestone: true, has_grade: true)
tt_igse.topics.create!(name: "Mock 50%", time: 4, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
tt_igse.topics.create!(name: "Introduction", time: 3, unit: "Unit 4 - Travel and tourism products and services")
tt_igse.topics.create!(name: "Topic 4.1 - Identify and describe tourism products", time: 5, unit: "Unit 4 - Travel and tourism products and services")
tt_igse.topics.create!(name: "Topic 4.2 - Explore the roles of tour operators and travel agents", time: 5, unit: "Unit 4 - Travel and tourism products and services")
tt_igse.topics.create!(name: "Topic 4.3 - Describe support facilities for travel and tourism", time: 5, unit: "Unit 4 - Travel and tourism products and services")
tt_igse.topics.create!(name: "Topic 4.4 - Explore the features of worldwide transport in relation to major international routes", time: 5, unit: "Unit 4 - Travel and tourism products and services")
tt_igse.topics.create!(name: "Final Assessments", time: 6, unit: "Unit 4 - Travel and tourism products and services", milestone: true, has_grade: true)
tt_igse.topics.create!(name: "Introduction", time: 3, unit: "Unit 5 - Marketing and promotion")
tt_igse.topics.create!(name: "Role and function of marketing and promotion", time: 7, unit: "Unit 5 - Marketing and promotion")
tt_igse.topics.create!(name: "Market segmentation and targeting", time: 7, unit: "Unit 5 - Marketing and promotion")
tt_igse.topics.create!(name: "Product as part of marketing mix", time: 8, unit: "Unit 5 - Marketing and promotion")
tt_igse.topics.create!(name: "Price as part of marketing mix", time: 8, unit: "Unit 5 - Marketing and promotion")
tt_igse.topics.create!(name: "Place as part of the marketing mix", time: 7, unit: "Unit 5 - Marketing and promotion")
tt_igse.topics.create!(name: "Promotion as part of marketing mix", time: 8, unit: "Unit 5 - Marketing and promotion")
tt_igse.topics.create!(name: "Final Assessments", time: 6, unit: "Unit 5 - Marketing and promotion", milestone: true, has_grade: true)
tt_igse.topics.create!(name: "The operation, role, and function of tourist boards and tourist information centres", time: 5, unit: "Unit 6 - The marketing and promotion of visitor services")
tt_igse.topics.create!(name: "The provision of tourist products and services", time: 5, unit: "Unit 6 - The marketing and promotion of visitor services")
tt_igse.topics.create!(name: "Basic principles of marketing and promotion", time: 5, unit: "Unit 6 - The marketing and promotion of visitor services")
tt_igse.topics.create!(name: "The marketing mix", time: 5, unit: "Unit 6 - The marketing and promotion of visitor services")
tt_igse.topics.create!(name: "Leisure travel services", time: 5, unit: "Unit 6 - The marketing and promotion of visitor services")
tt_igse.topics.create!(name: "Business travel services", time: 5, unit: "Unit 6 - The marketing and promotion of visitor services")
tt_igse.topics.create!(name: "Assessments - Coursework", time: 15, unit: "Unit 6 - The marketing and promotion of visitor services", milestone: true, has_grade: true)
tt_igse.topics.create!(name: "Mock 100%", time: 3, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)


english_igcse = Subject.create!(
  name: "English IGCSE",
  category: :igcse,
  )

  english_igcse.topics.create!(name: "Topic 1.1: Note-Taking: Cornell Notes and Annotating", time: 2, unit: "Unit 1: The Foundations")
  english_igcse.topics.create!(name: "Topic 1.2: Language Matters", time: 9.2, unit: "Unit 1: The Foundations")
  english_igcse.topics.create!(name: "Topic 1.3: Audience and Purpose", time: 5.6, unit: "Unit 1: The Foundations")
  english_igcse.topics.create!(name: "Topic 1.4: The Paragraph", time: 5.2, unit: "Unit 1: The Foundations")
  english_igcse.topics.create!(name: "Topic 1.5: The Essay", time: 2, unit: "Unit 1: The Foundations")
  english_igcse.topics.create!(name: "Topic 1.6: Creating Meaning", time: 7.8, unit: "Unit 1: The Foundations")
  english_igcse.topics.create!(name: "Topic 2.1: Letters", time: 2.8, unit: "Unit 2: Language and Thought")
  english_igcse.topics.create!(name: "Topic 2.2: Autobiography and Biography", time: 1.6, unit: "Unit 2: Language and Thought")
  english_igcse.topics.create!(name: "Topic 2.3: Articles", time: 2.6, unit: "Unit 2: Language and Thought")
  english_igcse.topics.create!(name: "Topic 2.4: Reports/Leaflets", time: 1.6, unit: "Unit 2: Language and Thought")
  english_igcse.topics.create!(name: "Topic 2.5: Speeches", time: 4.6, unit: "Unit 2: Language and Thought")
  english_igcse.topics.create!(name: "Topic 3.1: Context and Background: Animal Farm", time: 8.7, unit: "Unit 3: Language and Power")
  english_igcse.topics.create!(name: "Topic 3.2: Chapters 1-3", time: 6.1, unit: "Unit 3: Language and Power")
  english_igcse.topics.create!(name: "Topic 3.3: Chapters 4-6", time: 6.1, unit: "Unit 3: Language and Power")
  english_igcse.topics.create!(name: "Topic 3.4: Chapters 7-10", time: 5.1, unit: "Unit 3: Language and Power")
  english_igcse.topics.create!(name: "Topic 3.5: Argumentative Writing", time: 4.6, unit: "Unit 3: Language and Power")
  english_igcse.topics.create!(name: "Topic 4.1: The Comparative Essay", time: 2.8, unit: "Unit 4 The Individual and Social Responsibility")
  english_igcse.topics.create!(name: "Mock 50%", time: 8.7, unit: "Mock 50%", milestone: true, has_grade: true, Mock50: true)
  english_igcse.topics.create!(name: "Topic 5.1: Inquiry Project", time: 4.2, unit: "Unit 5: The Comparative Essay")
  english_igcse.topics.create!(name: "Topic 6.1: Introduction to Descriptive Writing. Painting with Words.", time: 3.8, unit: "Unit 6: Descriptive Writing and Fahrenheit 451")
  english_igcse.topics.create!(name: "Topic 6.2: Introduction to Fahrenheit 451. Context is Everything!", time: 2.6, unit: "Unit 6: Descriptive Writing and Fahrenheit 452")
  english_igcse.topics.create!(name: "Topic 6.3: Fahrenheit 451: The Hearth and the Salamander", time: 6.1, unit: "Unit 6: Descriptive Writing and Fahrenheit 453")
  english_igcse.topics.create!(name: "Topic 6.4: Fahrenheit 451: Sieve and Sand", time: 6.1, unit: "Unit 6: Descriptive Writing and Fahrenheit 454")
  english_igcse.topics.create!(name: "Topic 6.5: Fahrenheit 451: Burning Bright", time: 2.1, unit: "Unit 6: Descriptive Writing and Fahrenheit 455")
  english_igcse.topics.create!(name: "Topic 7.1: Elements of Story Telling", time: 11.3, unit: "Unit 7: Narrative Writing and Introduction to Of Mice and Men")
  english_igcse.topics.create!(name: "Topic 7.2: Conflict - Driving a Story", time: 1.6, unit: "Unit 7: Narrative Writing and Introduction to Of Mice and Men")
  english_igcse.topics.create!(name: "Topic 7.3: The Shape of a Story - Story Stages, Mood and Tension.", time: 4.6, unit: "Unit 7: Narrative Writing and Introduction to Of Mice and Men")
  english_igcse.topics.create!(name: "Topic 8.1: Section C of Exam", time: 0.5, unit: "Unit 8: Approaching Section C of Exam")
  english_igcse.topics.create!(name: "Topic 8.1: Titles in the Section C of Exam", time: 1.5, unit: "Unit 8: Approaching Section C of Exam")
  english_igcse.topics.create!(name: "Topic 9.1: Revision - Study Tips and Past Papers for Practice.", time: 4.6, unit: "Unit 9: Revision - Study Tips and Past Papers for Practice.")
  english_igcse.topics.create!(name: "Mock 100%", time: 4.2, unit: "Mock 100%", milestone: true, has_grade: true, Mock100: true)


afrikaans = Subject.create!(
  name: "Afrikaans IGCSE",
  category: :igcse,
  )

  afrikaans.topics.create!(name: "Unit 0: Review", time: 10, unit: "Review")
  afrikaans.topics.create!(name: "Unit 1: Lees en Beantwoord", time: 5, unit: "Lees en Beantwoord")
  afrikaans.topics.create!(name: "Unit 2: Dra inligting oor op 'n gegewe vorm", time: 5, unit: "Voltooi die vorm")
  afrikaans.topics.create!(name: "Unit 3: Lees die leestuk en voltooi die aantekeninge wat volg", time: 5, unit: "Maak aanterkoninge")
  afrikaans.topics.create!(name: "Unit 4: Maak 'n opsomming van die teks", time: 5, unit: "Maak 'n opsomming")
  afrikaans.topics.create!(name: "Unit 5: Skryf 'n informele brief", time: 5, unit: "Kort skryfwerk")
  afrikaans.topics.create!(name: "Unit 6: Hoe om 'n begripstoets te beantwoord", time: 7, unit: "Leesoefening")
  afrikaans.topics.create!(name: "Unit 7: Langer skryf opdrag", time: 8, unit: "Lang skryfoefening")
  afrikaans.topics.create!(name: "Mock 50%", time: 3, unit: "50% mock exam", milestone: true, has_grade: true, Mock50: true)
  afrikaans.topics.create!(name: "Unit 8: Luisteroefening 1", time: 5, unit: "Luisteroefening 1")
  afrikaans.topics.create!(name: "Unit 9: Luisteroefening 2", time: 5, unit: "Luisteroefening 2")
  afrikaans.topics.create!(name: "Unit 10: Die Skoenmaker se Kitaar", time: 5, unit: "Die Skoenmaker se Kitaar")
  afrikaans.topics.create!(name: "Unit 11: Die Houtkapper", time: 5, unit: "Die Houtkapper")
  afrikaans.topics.create!(name: "Unit 12: Ek is jammer", time: 5, unit: "Ek is jammer")
  afrikaans.topics.create!(name: "Extra Leesoefening", time: 5, unit: "Extra Leesoefening")
  afrikaans.topics.create!(name: "Exam preparation", time: 5, unit: "Exam preparation")
  afrikaans.topics.create!(name: "100% Mock exam", time: 3, unit: "100% mock exam", milestone: true, has_grade: true, Mock100: true)

  portuguesesl = Subject.create!(
    name: "Portuguese Second Language GCSE",
    category: :igcse,
    )

    portuguesesl.topics.create!(name: "1.1 O Alfabeto (The Alphabet)", time: 2.5, unit: "Unidade 1")
    portuguesesl.topics.create!(name: "1.2 Saudações Formais e Informais (Formal and Informal greetings)", time: 1.5, unit: "Unidade 1")
    portuguesesl.topics.create!(name: "1.3 Pronomes (Pronouns)", time: 2.5, unit: "Unidade 1")
    portuguesesl.topics.create!(name: "1.4 Apresentação Pessoal (Introducing Yourself)", time: 3.5, unit: "Unidade 1")
    portuguesesl.topics.create!(name: "2.1 O verbo SER", time: 3.5, unit: "Unidade 2")
    portuguesesl.topics.create!(name: "2.2 Palavras femininas e Masculinas e Profissões", time: 1.5, unit: "Unidade 2")
    portuguesesl.topics.create!(name: "2.3 Familia, o verbo ter e os possetivos", time: 4.0, unit: "Unidade 2")
    portuguesesl.topics.create!(name: "2.4 O verbo TER", time: 4.0, unit: "Unidade 2")
    portuguesesl.topics.create!(name: "3.1 O verbo ESTAR e os sentimentos", time: 3.5, unit: "Unidade 3")
    portuguesesl.topics.create!(name: "3.2 Verbos regulares no Presente de Indicativo", time: 4.0, unit: "Unidade 3")
    portuguesesl.topics.create!(name: "3.3 Rotina", time: 4.0, unit: "Unidade 3")
    portuguesesl.topics.create!(name: "3.4 Dias da semana - Meses do ano", time: 3.0, unit: "Unidade 3")
    portuguesesl.topics.create!(name: "4.1 A morada e meios de transportes", time: 2.5, unit: "Unidade 4")
    portuguesesl.topics.create!(name: "4.2 As horas", time: 3.0, unit: "Unidade 4")
    portuguesesl.topics.create!(name: "4.3 vestuário", time: 3.0, unit: "Unidade 4")
    portuguesesl.topics.create!(name: "4.4 As cores e a concordância", time: 4.0, unit: "Unidade 4")
    portuguesesl.topics.create!(name: "5.1 Comidas", time: 3.0, unit: "Unidade 5")
    portuguesesl.topics.create!(name: "5.2 Fazer um pedido", time: 4.0, unit: "Unidade 5")
    portuguesesl.topics.create!(name: "5.3 Expressar gosto e preferência", time: 4.0, unit: "Unidade 5")
    portuguesesl.topics.create!(name: "5.4 Hábitos saudáveis", time: 3.5, unit: "Unidade 5")
    portuguesesl.topics.create!(name: "5.5  Verbos irregulares no presente", time: 4.0, unit: "Unidade 5")
    portuguesesl.topics.create!(name: "Mock Exam 50%", time: 3.0, unit: "Mock Exam 50%", milestone: true, has_grade: true, Mock50: true)
    portuguesesl.topics.create!(name: "6.1 Pronomes interrogativos", time: 4.0, unit: "Unidade 6")
    portuguesesl.topics.create!(name: "6.2 Imperativo", time: 4.0, unit: "Unidade 6")
    portuguesesl.topics.create!(name: "6.3 Gerúndio e Particípio", time: 4.0, unit: "Unidade 6")
    portuguesesl.topics.create!(name: "6.4 Partes do corpo + consulta médica", time: 4.0, unit: "Unidade 6")
    portuguesesl.topics.create!(name: "6.5 Adjetivos e descrição fisica", time: 3.0, unit: "Unidade 6")
    portuguesesl.topics.create!(name: "6.6 Futuro na forma de presente", time: 3.5, unit: "Unidade 6")
    portuguesesl.topics.create!(name: "7.1 A escola", time: 3.0, unit: "Unidade 7")
    portuguesesl.topics.create!(name: "7.2 Preposições", time: 4.0, unit: "Unidade 7")
    portuguesesl.topics.create!(name: "7.3 Lugares da cidade + dar indicações", time: 4.0, unit: "Unidade 7")
    portuguesesl.topics.create!(name: "7.4 Desportos e hábitos saudáveis", time: 4.5, unit: "Unidade 7")
    portuguesesl.topics.create!(name: "7.5 Partes da Casa", time: 6.5, unit: "Unidade 7")
    portuguesesl.topics.create!(name: "8.1 Pretérito perfeito", time: 5.0, unit: "Unidade 8")
    portuguesesl.topics.create!(name: "8.2 Relato de viagem", time: 4.0, unit: "Unidade 8")
    portuguesesl.topics.create!(name: "8.3 Pretérito Imperfeito", time: 4.0, unit: "Unidade 8")
    portuguesesl.topics.create!(name: "8.4 A infância", time: 6.0, unit: "Unidade 8")
    portuguesesl.topics.create!(name: "9.1 Adverbios e conjunções", time: 4.0, unit: "Unidade 9")
    portuguesesl.topics.create!(name: "9.2 Fazer comparações + diminutivos e aumentativos", time: 4.0, unit: "Unidade 9")
    portuguesesl.topics.create!(name: "9.3 O futuro", time: 4.0, unit: "Unidade 9")
    portuguesesl.topics.create!(name: "9.4 Expressões idiomáticas", time: 2.0, unit: "Unidade 9")
    portuguesesl.topics.create!(name: "9.5 Colocação dos pronomes", time: 4.0, unit: "Unidade 9")
    portuguesesl.topics.create!(name: "9.6 Conjuntivo", time: 5.0, unit: "Unidade 9")
    portuguesesl.topics.create!(name: "Mock Exam 100%", time: 1.5, unit: "Mock Exam 100%", milestone: true, has_grade: true, Mock100: true)

    spanishsl = Subject.create!(
      name: "Spanish Foreign Language IGCSE",
      category: :igcse,
      )

      spanishsl.topics.create!(name: "0.1. Aprender español", time: 2, unit: "Unidad 1")
      spanishsl.topics.create!(name: "1.1. Rincón gramatical", time: 1, unit: "Unidad 1")
      spanishsl.topics.create!(name: "1.1. Yo y mis cosas", time: 3, unit: "Unidad 1")
      spanishsl.topics.create!(name: "1.1. Punto de verificación", time: 3, unit: "Unidad 1")
      spanishsl.topics.create!(name: "1.2. Rincón gramatical", time: 1, unit: "Unidad 1")
      spanishsl.topics.create!(name: "1.2. Mi día a día", time: 3, unit: "Unidad 1")
      spanishsl.topics.create!(name: "1.2. Punto de verificación", time: 3, unit: "Unidad 1")
      spanishsl.topics.create!(name: "1.3. Rincón gramatical", time: 1, unit: "Unidad 1")
      spanishsl.topics.create!(name: "1.3. Mi casa y mi ciudad", time: 3, unit: "Unidad 1")
      spanishsl.topics.create!(name: "1.3. Punto de verificación", time: 3, unit: "Unidad 1")
      spanishsl.topics.create!(name: "1.4. Rincón gramatical", time: 1, unit: "Unidad 1")
      spanishsl.topics.create!(name: "1.4. Mi escuela, mi clase y mis profesores", time: 3, unit: "Unidad 1")
      spanishsl.topics.create!(name: "1.4. Punto de verificación", time: 3, unit: "Unidad 1")
      spanishsl.topics.create!(name: "2.1. Rincón gramatical", time: 1, unit: "Unidad 2")
      spanishsl.topics.create!(name: "2.1. Familia y amigos", time: 3, unit: "Unidad 2")
      spanishsl.topics.create!(name: "2.1. Punto de verificación", time: 3, unit: "Unidad 2")
      spanishsl.topics.create!(name: "2.2. Rincón gramatical", time: 1, unit: "Unidad 2")
      spanishsl.topics.create!(name: "2.2. Mascotas y aficiones", time: 3, unit: "Unidad 2")
      spanishsl.topics.create!(name: "2.2. Punto de verificación", time: 3, unit: "Unidad 2")
      spanishsl.topics.create!(name: "2.3. Rincón gramatical", time: 1, unit: "Unidad 2")
      spanishsl.topics.create!(name: "2.3. Me gusta el deporte", time: 3, unit: "Unidad 2")
      spanishsl.topics.create!(name: "2.3. Punto de verificación", time: 3, unit: "Unidad 2")
      spanishsl.topics.create!(name: "2.4. Rincón gramatical", time: 1, unit: "Unidad 2")
      spanishsl.topics.create!(name: "2.4. Dieta saludable", time: 3, unit: "Unidad 2")
      spanishsl.topics.create!(name: "2.4. Punto de verificación", time: 3, unit: "Unidad 2")
      spanishsl.topics.create!(name: "Mock Exam 50%", time: 3, unit: "Mock Exam 50%", milestone: true, has_grade: true, Mock50: true)
      spanishsl.topics.create!(name: "3.1. Rincón gramatical", time: 1, unit: "Unidad 3")
      spanishsl.topics.create!(name: "3.1. Salir y divertirse", time: 3, unit: "Unidad 3")
      spanishsl.topics.create!(name: "3.1. Punto de verificación", time: 3, unit: "Unidad 3")
      spanishsl.topics.create!(name: "3.2. Rincón gramatical", time: 1, unit: "Unidad 3")
      spanishsl.topics.create!(name: "3.2. Fiestas y celebraciones", time: 3, unit: "Unidad 3")
      spanishsl.topics.create!(name: "3.2. Punto de verificación", time: 3, unit: "Unidad 3")
      spanishsl.topics.create!(name: "3.3. Rincón gramatical", time: 1, unit: "Unidad 3")
      spanishsl.topics.create!(name: "3.3. El restaurante", time: 3, unit: "Unidad 3")
      spanishsl.topics.create!(name: "3.3. Punto de verificación", time: 3, unit: "Unidad 3")
      spanishsl.topics.create!(name: "3.4. Rincón gramatical", time: 1, unit: "Unidad 3")
      spanishsl.topics.create!(name: "3.4. Las compras", time: 3, unit: "Unidad 3")
      spanishsl.topics.create!(name: "3.4. Punto de verificación", time: 3, unit: "Unidad 3")
      spanishsl.topics.create!(name: "4.1. Rincón gramatical", time: 1, unit: "Unidad 4")
      spanishsl.topics.create!(name: "4.1. Los problemas de mi ciudad", time: 3, unit: "Unidad 4")
      spanishsl.topics.create!(name: "4.1. Punto de verificación", time: 3, unit: "Unidad 4")
      spanishsl.topics.create!(name: "4.2. Rincón gramatical", time: 1, unit: "Unidad 4")
      spanishsl.topics.create!(name: "4.2. El estado del planeta", time: 3, unit: "Unidad 4")
      spanishsl.topics.create!(name: "4.2. Punto de verificación", time: 3, unit: "Unidad 4")
      spanishsl.topics.create!(name: "4.3. Rincón gramatical", time: 1, unit: "Unidad 4")
      spanishsl.topics.create!(name: "4.3. Recursos naturales", time: 3, unit: "Unidad 4")
      spanishsl.topics.create!(name: "4.3. Punto de verificación", time: 3, unit: "Unidad 4")
      spanishsl.topics.create!(name: "4.4. Rincón gramatical", time: 1, unit: "Unidad 4")
      spanishsl.topics.create!(name: "4.4. Cuidemos el medio ambiente", time: 3, unit: "Unidad 4")
      spanishsl.topics.create!(name: "4.4. Punto de verificación", time: 3, unit: "Unidad 4")
      spanishsl.topics.create!(name: "Mock Exam 100%", time: 3, unit: "Mock Exam 100%", milestone: true, has_grade: true, Mock100: true)

      environmental_mgmt = Subject.create!(
        name: "Environmental Management IGCSE",
        category: :igcse,
        )

        environmental_mgmt.topics.create!(name: "1.1 Formation of rocks", time: 3, unit: "1. Rocks and minerals and their exploitation")
        environmental_mgmt.topics.create!(name: "1.2 Extraction of rocks and minerals from the Earth", time: 3, unit: "1. Rocks and minerals and their exploitation")
        environmental_mgmt.topics.create!(name: "1.3 Impact of rock and mineral extraction", time: 5, unit: "1. Rocks and minerals and their exploitation")
        environmental_mgmt.topics.create!(name: "1.4 Managing the impact of rock and mineral extraction", time: 2, unit: "1. Rocks and minerals and their exploitation")
        environmental_mgmt.topics.create!(name: "1.5 Sustainable use of rocks and minerals", time: 6, unit: "1. Rocks and minerals and their exploitation")
        environmental_mgmt.topics.create!(name: "Checkpoint 1: Rocks and minerals and their exploitation (1.1 - 1.5)", time: 1, unit: "1. Rocks and minerals and their exploitation")
        environmental_mgmt.topics.create!(name: "2.1 Fossil fuel formation", time: 5, unit: "2. Energy and the environment")
        environmental_mgmt.topics.create!(name: "2.2 Energy resources and the generation of electricity", time: 4, unit: "2. Energy and the environment")
        environmental_mgmt.topics.create!(name: "2.3 Energy demand", time: 2, unit: "2. Energy and the environment")
        environmental_mgmt.topics.create!(name: "2.4 Conservation and management of energy resources", time: 3, unit: "2. Energy and the environment")
        environmental_mgmt.topics.create!(name: "2.5 Impact of oil pollution", time: 2, unit: "2. Energy and the environment")
        environmental_mgmt.topics.create!(name: "2.6 Management of oil pollution", time: 5, unit: "2. Energy and the environment")
        environmental_mgmt.topics.create!(name: "Checkpoint 2: Energy and the environment (2.1 - 2.6)", time: 0.5, unit: "2. Energy and the environment")
        environmental_mgmt.topics.create!(name: "3.1 Soil composition", time: 2, unit: "3. Agriculture and the environment")
        environmental_mgmt.topics.create!(name: "3.2 Soils for plant growth", time: 4, unit: "3. Agriculture and the environment")
        environmental_mgmt.topics.create!(name: "3.3 Agriculture types", time: 3, unit: "3. Agriculture and the environment")
        environmental_mgmt.topics.create!(name: "3.4 Increasing agricultural yields", time: 3, unit: "3. Agriculture and the environment")
        environmental_mgmt.topics.create!(name: "3.5 The impact of agriculture", time: 3, unit: "3. Agriculture and the environment")
        environmental_mgmt.topics.create!(name: "3.6 Causes and impacts of soil erosion", time: 4, unit: "3. Agriculture and the environment")
        environmental_mgmt.topics.create!(name: "3.7 Managing soil erosion", time: 3, unit: "3. Agriculture and the environment")
        environmental_mgmt.topics.create!(name: "3.8 Sustainable agriculture", time: 5, unit: "3. Agriculture and the environment")
        environmental_mgmt.topics.create!(name: "Checkpoint 3: Agriculture and the environment (3.1 - 3.8)", time: 1, unit: "3. Agriculture and the environment")
        environmental_mgmt.topics.create!(name: "4.1 Global water distribution", time: 2, unit: "4. Water and its management")
        environmental_mgmt.topics.create!(name: "4.2 The water cycle", time: 5, unit: "4. Water and its management")
        environmental_mgmt.topics.create!(name: "4.3 Water supply", time: 2, unit: "4. Water and its management")
        environmental_mgmt.topics.create!(name: "4.4 Water sources and usage", time: 2, unit: "4. Water and its management")
        environmental_mgmt.topics.create!(name: "4.5 Water quality and availability", time: 2, unit: "4. Water and its management")
        environmental_mgmt.topics.create!(name: "4.6 Multipurpose dam projects", time: 2, unit: "4. Water and its management")
        environmental_mgmt.topics.create!(name: "4.7 Sources, impact and management of water pollution", time: 5, unit: "4. Water and its management")
        environmental_mgmt.topics.create!(name: "4.8 Managing water-related disease", time: 6, unit: "4. Water and its management")
        environmental_mgmt.topics.create!(name: "Checkpoint 4: Water and its management (4.1 - 4.8)", time: 1, unit: "4. Water and its management")
        environmental_mgmt.topics.create!(name: "5.1 Oceans as a resource", time: 3, unit: "5. Oceans and fisheries")
        environmental_mgmt.topics.create!(name: "5.2 World fisheries", time: 5, unit: "5. Oceans and fisheries")
        environmental_mgmt.topics.create!(name: "5.3 Exploitation of the oceans: impact on fisheries", time: 4, unit: "5. Oceans and fisheries")
        environmental_mgmt.topics.create!(name: "5.4 Management of the harvesting of marine species", time: 6, unit: "5. Oceans and fisheries")
        environmental_mgmt.topics.create!(name: "Checkpoint 5: Oceans and fisheries (5.1 - 5.4)", time: 1, unit: "5. Oceans and fisheries")
        environmental_mgmt.topics.create!(name: "50% Mock exam", time: 2, unit: "50% Mock exam", milestone: true, has_grade: true, Mock50: true)
        environmental_mgmt.topics.create!(name: "6.1 What is a natural hazard?", time: 5, unit: "6. Managing natural hazards")
        environmental_mgmt.topics.create!(name: "6.2 Earthquakes and volcanoes", time: 6, unit: "6. Managing natural hazards")
        environmental_mgmt.topics.create!(name: "6.3 Tropical cyclones", time: 3, unit: "6. Managing natural hazards")
        environmental_mgmt.topics.create!(name: "6.4 Flooding", time: 3, unit: "6. Managing natural hazards")
        environmental_mgmt.topics.create!(name: "6.5 Drought", time: 3, unit: "6. Managing natural hazards")
        environmental_mgmt.topics.create!(name: "6.6 The impacts of natural hazards", time: 3, unit: "6. Managing natural hazards")
        environmental_mgmt.topics.create!(name: "6.7 Managing the impacts of natural hazards", time: 3, unit: "6. Managing natural hazards")
        environmental_mgmt.topics.create!(name: "6.8 Opportunities presented by natural hazards", time: 6, unit: "6. Managing natural hazards")
        environmental_mgmt.topics.create!(name: "Checkpoint 6: Managing natural hazards (6.1 - 6.8)", time: 1, unit: "6. Managing natural hazards")
        environmental_mgmt.topics.create!(name: "7.1 The atmosphere", time: 5, unit: "7. The atmosphere and human activities")
        environmental_mgmt.topics.create!(name: "7.2 Atmospheric pollution and its causes", time: 3, unit: "7. The atmosphere and human activities")
        environmental_mgmt.topics.create!(name: "7.3 Impact of atmospheric pollution", time: 3, unit: "7. The atmosphere and human activities")
        environmental_mgmt.topics.create!(name: "7.4 Managing atmospheric pollution", time: 5, unit: "7. The atmosphere and human activities")
        environmental_mgmt.topics.create!(name: "Checkpoint 7: The atmosphere and human activities (7.1 - 7.4)", time: 1, unit: "7. The atmosphere and human activities")
        environmental_mgmt.topics.create!(name: "8.1 Human population distribution and density", time: 3, unit: "8. Human population")
        environmental_mgmt.topics.create!(name: "8.2 Changes in population size", time: 5, unit: "8. Human population")
        environmental_mgmt.topics.create!(name: "8.3 Population structure", time: 3, unit: "8. Human population")
        environmental_mgmt.topics.create!(name: "8.4 Managing human population size", time: 5, unit: "8. Human population")
        environmental_mgmt.topics.create!(name: "Checkpoint 8: Human population (8.1 - 8.4)", time: 1, unit: "8. Human population")
        environmental_mgmt.topics.create!(name: "9.1 Ecosystems", time: 6, unit: "9. Natural ecosystems and human activities")
        environmental_mgmt.topics.create!(name: "9.2 Ecosystems under threat", time: 6, unit: "9. Natural ecosystems and human activities")
        environmental_mgmt.topics.create!(name: "9.3 Deforestation", time: 3, unit: "9. Natural ecosystems and human activities")
        environmental_mgmt.topics.create!(name: "9.4 Managing forests", time: 3, unit: "9. Natural ecosystems and human activities")
        environmental_mgmt.topics.create!(name: "9.5 Measuring and managing biodiversity", time: 5, unit: "9. Natural ecosystems and human activities")
        environmental_mgmt.topics.create!(name: "Checkpoint 9: Natural ecosystems and human activities (9.1 - 9.5)", time: 1, unit: "9. Natural ecosystems and human activities")
        environmental_mgmt.topics.create!(name: "100% Mock exam", time: 2, unit: "100% Mock exam", milestone: true, has_grade: true, Mock100: true)

  projeto1 = Subject.create!(
    name: "P1 - Good health and well-being - LWS Y9",
    category: :lws,
    )

  projeto1.topics.create!(name: "Let's learn - What is a Mixed Number?", time: 1, unit: "Maths")
  projeto1.topics.create!(name: "Let's Watch - Operations with Mixed Numbers", time: 1, unit: "Maths")
  projeto1.topics.create!(name: "Multiplying and Dividing Fractions Quiz — Let's Practise", time: 1, unit: "Maths")
  projeto1.topics.create!(name: "Adding and Subtracting Mixed Numbers Quiz — Let's Practise", time: 1, unit: "Maths")
  projeto1.topics.create!(name: "Multiplying and Dividing Mixed Numbers Quiz — Let's Practise", time: 1, unit: "Maths")
  projeto1.topics.create!(name: "Word Problems Involving Fractions Quiz — Let's Practise", time: 1, unit: "Maths")
  projeto1.topics.create!(name: "Let's Learn - Reverse Percentages and Percentage Change", time: 1, unit: "Maths")
  projeto1.topics.create!(name: "Let's Watch - Reverse Percentages and Percentage Change", time: 1, unit: "Maths")
  projeto1.topics.create!(name: "Reverse Percentages and Percentage Change Quiz — Let's Practise", time: 1, unit: "Maths")
  projeto1.topics.create!(name: "Let's Watch - Direct and Inverse Proportion", time: 1, unit: "Maths")
  projeto1.topics.create!(name: "Direct and Inverse Proportion Quiz — Let's Practise", time: 1, unit: "Maths")
  projeto1.topics.create!(name: "Let's Check your Understanding - Cross Topic Quiz Numbers", time: 1, unit: "Maths")
  projeto1.topics.create!(name: "1.1 Introduction", time: 1, unit: "Learning Through Research")
  projeto1.topics.create!(name: "1.2 Plate Pioneerz", time: 1, unit: "Learning Through Research")
  projeto1.topics.create!(name: "1.3 Healthy Kids Around the World", time: 1, unit: "Learning Through Research")
  projeto1.topics.create!(name: "1.4 Diseases and Well Being", time: 1, unit: "Learning Through Research")
  projeto1.topics.create!(name: "Final Project: Your Weekly Plan for a Healthy Lifestyle - Let´s Check your Understanding!", time: 1, unit: "Learning Through Research")
  projeto1.topics.create!(name: "1.1 Air Pollution", time: 1, unit: "Science")
  projeto1.topics.create!(name: "1.1 Air Pollution — Let's Check your Understanding!", time: 1, unit: "Science")
  projeto1.topics.create!(name: "1.2 Global Warming", time: 1, unit: "Science")
  projeto1.topics.create!(name: "1.2 Climate Change and Laws — Let's Debate!", time: 1, unit: "Science")
  projeto1.topics.create!(name: "1.3 Water Pollution", time: 1, unit: "Science")
  projeto1.topics.create!(name: "1.4 Land Use", time: 1, unit: "Science")
  projeto1.topics.create!(name: "Project 1 — Let's Check your Understanding!", time: 1, unit: "Science")
  projeto1.topics.create!(name: "1.1 Textos dos Media e do Quotidiano:  Publicidade", time: 1, unit: "Português")
  projeto1.topics.create!(name: "1.1 Publicidade Comercial vs. Publicidade Institucional — Let's Check your Understanding!", time: 1, unit: "Português")
  projeto1.topics.create!(name: "1.2 Texto de Opinião", time: 1, unit: "Português")
  projeto1.topics.create!(name: "1.2 Compreensão: Texto de Opinião — Let's Check your Understanding!", time: 1, unit: "Português")
  projeto1.topics.create!(name: "1.3 Entrevista", time: 1, unit: "Português")
  projeto1.topics.create!(name: "1.3 Let's Check your Understanding!", time: 1, unit: "Português")
  projeto1.topics.create!(name: "1.4 Roteiro turístico", time: 1, unit: "Português")
  projeto1.topics.create!(name: "Let's Check your Understanding!", time: 1, unit: "Português")
  projeto1.topics.create!(name: "1.1 Fiction vs. Non-fiction texts: Can you tell the difference?", time: 1, unit: "English")
  projeto1.topics.create!(name: "1.1 Fiction or Non-fiction activity hand-in — Let's Check your Understanding!", time: 1, unit: "English")
  projeto1.topics.create!(name: "1.1 Let's Have a go at Writing! — Let's Check your Understanding!", time: 1, unit: "English")
  projeto1.topics.create!(name: "1.2 The Passion of Punctuation", time: 1, unit: "English")
  projeto1.topics.create!(name: "1.2 Punctuation in Action — Let's Check your Understanding!", time: 1, unit: "English")
  projeto1.topics.create!(name: "1.3 Summarising", time: 1, unit: "English")
  projeto1.topics.create!(name: "1.3 Summarising like a Pro! - Let´s Check your Understanding!", time: 1, unit: "English")
  projeto1.topics.create!(name: "1.4 The Art of Dialogue", time: 1, unit: "English")
  projeto1.topics.create!(name: "1.4 Dialogue, oh, Dialogue, how do I write you? — Let's Check your Understanding!", time: 1, unit: "English")

  projeto2 = Subject.create!(
    name: "P2 - Zero hunger - LWS Y9",
    category: :lws,
    )

    projeto2.topics.create!(name: "Let's Review - Decimals: Multiplying and Dividing", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Review - Ratios", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Review and Practise - Decimals, Percentages and Ratios", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Learn - Powers of 10", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Watch - More on Powers of 10: Scientific Notation (Standard Form)", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Practise - STEM Powers of 10", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Practise - Standard Form Quiz", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Practise - STEM: Calculating with Standard Form Quiz", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Learn - Index Notation", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Learn  - Laws", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Practise - Index Notation Quiz", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Learn - Rounding and Estimation", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Watch - Rounding and Estimation Examples", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Practise - Rounding and Estimation Quiz", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Learn - Bounds", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Practise - Upper and Lower Bounds", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "2.1 Introduction", time: 1, unit: "Learning Through Research")
    projeto2.topics.create!(name: "2.2 Fighting world hunger one game at a time", time: 1, unit: "Learning Through Research")
    projeto2.topics.create!(name: "2.3 Should we eat bugs?", time: 1, unit: "Learning Through Research")
    projeto2.topics.create!(name: "2.4 The Farmer Game", time: 1, unit: "Learning Through Research")
    projeto2.topics.create!(name: "Final Project: Design your own computer game — Let's Check your Understanding!?", time: 1, unit: "Learning Through Research")
    projeto2.topics.create!(name: "2.1 Autobiografias", time: 1, unit: "Português")
    projeto2.topics.create!(name: "2.1 A História da Minha Vida", time: 1, unit: "Português")
    projeto2.topics.create!(name: "2.2 Diário", time: 1, unit: "Português")
    projeto2.topics.create!(name: "2.2.2 Produção de Texto - Uma Página do meu Diário", time: 1, unit: "Português")
    projeto2.topics.create!(name: "2.3 Escrita Narrativa", time: 1, unit: "Português")
    projeto2.topics.create!(name: "2.3 Vamos Escrever! — Let's Check your Understanding!", time: 1, unit: "Português")
    projeto2.topics.create!(name: "2.4 O Género dos Nomes", time: 1, unit: "Português")
    projeto2.topics.create!(name: "2.4 Os Géneros em Português — Let's Check your Understanding!", time: 1, unit: "Português")
    projeto2.topics.create!(name: "2.1 Purpose of Texts", time: 1, unit: "English")
    projeto2.topics.create!(name: "2.1 The Purpose of Texts — Let's Check your Understanding!", time: 1, unit: "English")
    projeto2.topics.create!(name: "2.2 Audience of Texts", time: 1, unit: "English")
    projeto2.topics.create!(name: "2.2 Audience of Texts — Let's Check your Understanding!", time: 1, unit: "English")
    projeto2.topics.create!(name: "2.3 Context of Texts", time: 1, unit: "English")
    projeto2.topics.create!(name: "2.3 Context of Texts — Let's Check your Understanding!", time: 1, unit: "English")
    projeto2.topics.create!(name: "2.4 Tone in Writing", time: 1, unit: "English")
    projeto2.topics.create!(name: "2.4 Using Tone through Art — Let's Check your Understanding!", time: 1, unit: "English")
    projeto2.topics.create!(name: "Introduction", time: 1, unit: "Learning Through Research")
    projeto2.topics.create!(name: "Fighting world hunger one game at a time", time: 1, unit: "Learning Through Research")
    projeto2.topics.create!(name: "Should we eat bugs?", time: 1, unit: "Learning Through Research")
    projeto2.topics.create!(name: "The Farmer Game", time: 1, unit: "Learning Through Research")
    projeto2.topics.create!(name: "Final Project: Design your own computer game — Let's Check your Understanding!?", time: 1, unit: "Learning Through Research")
    projeto2.topics.create!(name: "Let's Review - Decimals: Multiplying and Dividing", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Review - Ratios", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Review and Practise - Decimals, Percentages and Ratios", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Learn - Powers of 10", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Watch - More on Powers of 10: Scientific Notation (Standard Form)", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Practise - STEM Powers of 10", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Practise - Standard Form Quiz", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Practise - STEM: Calculating with Standard Form Quiz", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Learn - Index Notation", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Learn  - Laws", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Practise - Index Notation Quiz", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Learn - Rounding and Estimation", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Watch - Rounding and Estimation Examples", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Practise - Rounding and Estimation Quiz", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Learn - Bounds", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Practise - Upper and Lower Bounds", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Practise - Question Bank I", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Practise - Question Bank I Answers", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Practise - Question Bank II", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's Practise - Question Bank II Answers", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Let's check your Understanding - Cross Topic Quiz Numbers", time: 1, unit: "Maths")
    projeto2.topics.create!(name: "Numbers checkpoint", time: 1, unit: "Maths")


    projeto3 = Subject.create!(
      name: "P3 - Affordable and Clean Energy - LWS Y9",
      category: :lws,
      )

  projeto3.topics.create!(name: "Let's Review and Learn - Algebra", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "Let's Review and Watch - Algebra", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "Let's Review and Watch -  Simplifying expressions", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "Let's Practise - Simplifying Expressions Quiz", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "Let's Review and Watch - Substituting into Expressions and Equations", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "Let's Watch -  Solving equations", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "Let's Practise - Substituting into Expressions", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "Let's Practise - Substituting into Formulas Quiz", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "Let's Practise - Solving Multi Step Equations Quiz", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "Let's Learn - Expanding Expressions", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "Let's Watch - Expanding Expressions", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "Let's Practise - Expanding Singles Brackets Quiz", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "Let's Learn - Factorising Expressions", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "Let's Practise - Factorising by a common factor", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "Let's Learn - Quadratic Equations", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "Let's Watch - Quadratic Equations", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "Let's Practise - Quadratic Formula", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "Let's Learn - System of Simultaneous Equations", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "Let's Practise - Simultaneous Equations", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "Let's Practise - Cross Topic Quiz Algebra", time: 1, unit: "Maths")
  projeto3.topics.create!(name: "3.1 Temperature and Energy", time: 1, unit: "Science")
  projeto3.topics.create!(name: "3.2 Heat Transfer on a Global Scale", time: 1, unit: "Science")
  projeto3.topics.create!(name: "3.3 The World's Energy Needs", time: 1, unit: "Science")
  projeto3.topics.create!(name: "3.4 Energy for the Future", time: 1, unit: "Science")
  projeto3.topics.create!(name: "1st Cross-Topic Practice — Let's Get Ready!", time: 1, unit: "Science")
  projeto3.topics.create!(name: "1st Cross-Topic Assessment — Let's Check your Progress!", time: 1, unit: "Science")
  projeto3.topics.create!(name: "3.1 Interpretação de texto", time: 1, unit: "Português")
  projeto3.topics.create!(name: "3.1 Interpretação de textos   --> Let's Check your Understanding!", time: 1, unit: "Português")
  projeto3.topics.create!(name: "3.2 Sinais de Pontuação", time: 1, unit: "Português")
  projeto3.topics.create!(name: "3.2 Sinais de Pontuação  --> Let's Check your Understanding!", time: 1, unit: "Português")
  projeto3.topics.create!(name: "3.3 Crítica", time: 1, unit: "Português")
  projeto3.topics.create!(name: "3.3.1 Crítica Literária   --> Let's Check your Understanding!", time: 1, unit: "Português")
  projeto3.topics.create!(name: "3.3.2 Crítica Cinematográfica   --> Let's Check your Understanding!", time: 1, unit: "Português")
  projeto3.topics.create!(name: "3.4 Escrita Criativa", time: 1, unit: "Português")
  projeto3.topics.create!(name: "3.4 Escrita Criativa   --> Let's Check your Understanding!", time: 1, unit: "Português")
  projeto3.topics.create!(name: "3.1 Imagery and Figurative Language", time: 1, unit: "English")
  projeto3.topics.create!(name: "3.1 Imagery and your Senses — Let's Check your Understanding!", time: 1, unit: "English")
  projeto3.topics.create!(name: "3.2 Figurative Language", time: 1, unit: "English")
  projeto3.topics.create!(name: "3.2 Identifying Figurative Language in Poetry — Let's Check your Understanding!", time: 1, unit: "English")
  projeto3.topics.create!(name: "3.3 Travel Writing", time: 1, unit: "English")
  projeto3.topics.create!(name: "3.3 Travel Writing - Let´s Check your Understanding!", time: 1, unit: "English")
  projeto3.topics.create!(name: "3.4 Descriptive Writing", time: 1, unit: "English")
  projeto3.topics.create!(name: "3.4 Descriptive Essay — Let's Check your Understanding!", time: 1, unit: "English")
  projeto3.topics.create!(name: "3.1 Renewable Energy Sources", time: 1, unit: "Learning Through Research")
  projeto3.topics.create!(name: "3.1 Tracking Down the Waster´s Gang! — Let's Check your Understanding!", time: 1, unit: "Learning Through Research")
  projeto3.topics.create!(name: "3.2 The boy who harnessed the world", time: 1, unit: "Learning Through Research")
  projeto3.topics.create!(name: "3.3 Building a Prototype", time: 1, unit: "Learning Through Research")
  projeto3.topics.create!(name: "Final Project: Renewable Energy Campaign — Let's Check your Understanding!", time: 1, unit: "Learning Through Research")

  projeto4 = Subject.create!(
    name: "P4 - No Poverty- LWS Y9",
    category: :lws,
    )

  projeto4.topics.create!(name: "4.1 Atomic Structure", time: 1, unit: "Science")
  projeto4.topics.create!(name: "4.2 The Periodic Table", time: 1, unit: "Science")
  projeto4.topics.create!(name: "4.3 Periodic Trends", time: 1, unit: "Science")
  projeto4.topics.create!(name: "4.3 Atomic Structure and Groups — Let's Investigate!", time: 1, unit: "Science")
  projeto4.topics.create!(name: "4.4 Groups of the Periodic Table", time: 1, unit: "Science")
  projeto4.topics.create!(name: "Project 4 — Let's Check your Understanding!", time: 1, unit: "Science")
  projeto4.topics.create!(name: "Year 9 - 50% Progression Test - Study Plan", time: 1, unit: "Science")
  projeto4.topics.create!(name: "Let's Collaborate: Science Notes", time: 1, unit: "Science")
  projeto4.topics.create!(name: "Science — 50% Progression Test Submission", time: 1, unit: "Science")
  projeto4.topics.create!(name: "4.1 Texto Poético", time: 1, unit: "Português")
  projeto4.topics.create!(name: "4.1.1 Let´s Check your Understanding! - Texto Poético 1", time: 1, unit: "Português")
  projeto4.topics.create!(name: "4.1.2 Let´s Check your Understanding! - Texto Poético 2", time: 1, unit: "Português")
  projeto4.topics.create!(name: "4.2 Acentuação das palavras", time: 1, unit: "Português")
  projeto4.topics.create!(name: "4.2 Let´s Check your Understanding! - Acentuação das palavras", time: 1, unit: "Português")
  projeto4.topics.create!(name: "4.3 Recursos Expressivos 1: Onomatopeia, Personificação e Metáfora", time: 1, unit: "Português")
  projeto4.topics.create!(name: "4.3.1 Let´s Check your Understanding! - Recursos Expressivos 1: Onomatopeia", time: 1, unit: "Português")
  projeto4.topics.create!(name: "4.3.2 Let´s Check your Understanding! - Recursos Expressivos 2: Personificação e Metáfora", time: 1, unit: "Português")
  projeto4.topics.create!(name: "4.4 Recursos expressivos 2: Hipérbole, Antítese e Eufemismo", time: 1, unit: "Português")
  projeto4.topics.create!(name: "4.4 - Let´s Check your Understanding! - Recursos Expressivos 2: Antítese", time: 1, unit: "Português")
  projeto4.topics.create!(name: "4.4 - Let´s Check your Understanding! - Recursos Expressivos 2: Eufemismo", time: 1, unit: "Português")
  projeto4.topics.create!(name: "4.1 Introduction", time: 1, unit: "Learning Through Research")
  projeto4.topics.create!(name: "4.2 Living on One Dollar a Day", time: 1, unit: "Learning Through Research")
  projeto4.topics.create!(name: "4.2 Living on One Dollar a Day - Let´s Check your Understanding!", time: 1, unit: "Learning Through Research")
  projeto4.topics.create!(name: "4.3 What did I see on my way today?", time: 1, unit: "Learning Through Research")
  projeto4.topics.create!(name: "4.3 What do I See? Let´s Check your Understanding!", time: 1, unit: "Learning Through Research")
  projeto4.topics.create!(name: "Final Project: No Poverty - Let´s Check your Understanding!", time: 1, unit: "Learning Through Research")
  projeto4.topics.create!(name: "Let's Review and Learn - Formulas", time: 1, unit: "Maths")
  projeto4.topics.create!(name: "Let's Watch - Substituting into Expressions and Formulas", time: 1, unit: "Maths")
  projeto4.topics.create!(name: "Let's Review and Practise - Substituting into Simple Expressions Quiz", time: 1, unit: "Maths")
  projeto4.topics.create!(name: "Let's Review and Practise - Substituting into simple Formulas and Rearranging Formulas in Context Quiz", time: 1, unit: "Maths")
  projeto4.topics.create!(name: "Let's Practise - Substituting into Formulas and Rearranging Formulas Quiz", time: 1, unit: "Maths")
  projeto4.topics.create!(name: "Let's Practise - Rearranging Harder Formulas Quiz", time: 1, unit: "Maths")
  projeto4.topics.create!(name: "Let's Learn - Introduction to Functions", time: 1, unit: "Maths")
  projeto4.topics.create!(name: "Let's Watch - Function Notation", time: 1, unit: "Maths")
  projeto4.topics.create!(name: "Let's Practise - Function Notation - Linear Functions Quiz", time: 1, unit: "Maths")
  projeto4.topics.create!(name: "Let's Practise - Function Notation - Quadratic Functions Quiz", time: 1, unit: "Maths")
  projeto4.topics.create!(name: "Let's Practise - Function Notation - Other Functions Quiz", time: 1, unit: "Maths")
  projeto4.topics.create!(name: "Let's Learn - Linear Sequences", time: 1, unit: "Maths")
  projeto4.topics.create!(name: "Let's Watch - Linear Sequences", time: 1, unit: "Maths")
  projeto4.topics.create!(name: "Let's Practise - Linear Sequences Quiz", time: 1, unit: "Maths")
  projeto4.topics.create!(name: "Let's Learn - Inequalities", time: 1, unit: "Maths")
  projeto4.topics.create!(name: "Let's Watch - Inequalities", time: 1, unit: "Maths")
  projeto4.topics.create!(name: "Let's Practise - Inequalities Quiz", time: 1, unit: "Maths")
  projeto4.topics.create!(name: "Mathematics — 50% Progression Test Model", time: 1, unit: "Maths")
  projeto4.topics.create!(name: "Mathematics — 50% Progression Test", time: 1, unit: "Maths")
  projeto4.topics.create!(name: "4.1 Introduction to the Diary of Anne Frank", time: 1, unit: "English")
  projeto4.topics.create!(name: "4.1 Context Clues - Let´s Check your Understanding!", time: 1, unit: "English")
  projeto4.topics.create!(name: "4.2 Guided Reading", time: 1, unit: "English")
  projeto4.topics.create!(name: "4.2 Reading Schedule - Let´s Check your Understanding!", time: 1, unit: "English")
  projeto4.topics.create!(name: "4.2 Reading Schedule - Let´s Check your Understanding!", time: 1, unit: "English")
  projeto4.topics.create!(name: "4.3 The Secret Annex", time: 1, unit: "English")
  projeto4.topics.create!(name: "4.3 The Secret Annex Guided Tour - Let´s Check your Understanding", time: 1, unit: "English")
  projeto4.topics.create!(name: "4.4 Poetry by Anne Frank", time: 1, unit: "English")
  projeto4.topics.create!(name: "4.4 Anne Frank Poetry - Let´s Check your Understanding!", time: 1, unit: "English")
  projeto4.topics.create!(name: "Project 4 Progression Test Study Plan!", time: 1, unit: "English")
  projeto4.topics.create!(name: "English — 50% Progression Test Submission", time: 1, unit: "English")

  projeto5 = Subject.create!(
    name: "P5 - Decent work and economic growth - LWS Y9",
    category: :lws,
    )

  projeto5.topics.create!(name: "Let's Review and Learn - Geometry: Foundations and Concepts", time: 1, unit: "Maths")
  projeto5.topics.create!(name: "Let's Review and Learn - Angles in Triangles", time: 1, unit: "Maths")
  projeto5.topics.create!(name: "Angles, Triangles and Lines Quiz- Difficulty level: Low", time: 1, unit: "Maths")
  projeto5.topics.create!(name: "Let's Review and Learn - Quadrilaterals", time: 1, unit: "Maths")
  projeto5.topics.create!(name: "Geometric Properties of Quadrilaterals Quiz - Difficulty level: Low", time: 1, unit: "Maths")
  projeto5.topics.create!(name: "Let's Learn and Watch - Pythagorean Theorem", time: 1, unit: "Maths")
  projeto5.topics.create!(name: "Pythagorean Theorem Quiz - Difficulty level: Medium", time: 1, unit: "Maths")
  projeto5.topics.create!(name: "Let's Learn and Watch - Congruence", time: 1, unit: "Maths")
  projeto5.topics.create!(name: "Congruence Quiz - Difficulty level: Low", time: 1, unit: "Maths")
  projeto5.topics.create!(name: "Let's Learn and Watch - Similarity", time: 1, unit: "Maths")
  projeto5.topics.create!(name: "Similarity Quiz - Difficulty level: Medium", time: 1, unit: "Maths")
  projeto5.topics.create!(name: "Let's check your understanding - Geometry Cross Topic Quiz- Difficulty level: Medium", time: 1, unit: "Maths")
  projeto5.topics.create!(name: "5.1 Introduction", time: 1, unit: "Learning Through Research")
  projeto5.topics.create!(name: "5.2 The Ins and Outs of Fairtrade", time: 1, unit: "Learning Through Research")
  projeto5.topics.create!(name: "5.3 Careers: What is my place in the world?", time: 1, unit: "Learning Through Research")
  projeto5.topics.create!(name: "5.4 Final Project: The World of Work!", time: 1, unit: "Learning Through Research")
  projeto5.topics.create!(name: "Final Project: The World of Work - Let´s Check Your Understanding", time: 1, unit: "Learning Through Research")
  projeto5.topics.create!(name: "5.1 Recursos expressivos: Aliteração, Anáfora, Enumeração, Perífrase, Comparação, Ironia e Pleonasmo.", time: 1, unit: "Português")
  projeto5.topics.create!(name: "5.1.1 Let's Check Your Understanding - Recursos expressivos: Aliteração, Anáfora, Enumeração, Perífase, Comparação, Ironia e Pleonasmo.", time: 1, unit: "Português")
  projeto5.topics.create!(name: "5.1.2 Let's Check Your Understanding - Recursos expressivos: Aliteração, Anáfora, Enumeração, Perífase, Comparação, Ironia e Pleonasmo.", time: 1, unit: "Português")
  projeto5.topics.create!(name: "5.1.2 Let's Check Your Understanding - Recursos expressivos: Aliteração, Anáfora, Enumeração, Perífase, Comparação, Ironia e Pleonasmo.", time: 1, unit: "Português")
  projeto5.topics.create!(name: "5.3.1 Let's Check Your Understanding -  Sujeito, Predicado e Vocativo", time: 1, unit: "Português")
  projeto5.topics.create!(name: "5.3.2 Let's Check Your Understanding - Funções Sintáticas: Complemento direto, complemento indireto e complemento oblíquo.", time: 1, unit: "Português")
  projeto5.topics.create!(name: "5.4 Let's Check Your Understanding - Funções Sintáticas: Complemento agente da passiva e predicativo do sujeito.", time: 1, unit: "Português")
  projeto5.topics.create!(name: "5.2 Funções Sintáticas: Sujeito, Predicado e Vocativo", time: 1, unit: "Português")
  projeto5.topics.create!(name: "5.3 - Funções Sintáticas: Complemento direto, complemento indireto e complemento oblíquo - OLD", time: 1, unit: "Português")
  projeto5.topics.create!(name: "5.4 - Funções Sintáticas: Complemento agente da passiva e predicativo do sujeito - OLD", time: 1, unit: "Português")
  projeto5.topics.create!(name: "5.1 The Wonderful World of Poetry", time: 1, unit: "English")
  projeto5.topics.create!(name: "5.1 Poetry Analysis - Let´s Check your Understanding!", time: 1, unit: "English")
  projeto5.topics.create!(name: "5.2 Types of Poems", time: 1, unit: "English")
  projeto5.topics.create!(name: "5.2 Picture Inspired Poetry - Let's Check your Understanding!", time: 1, unit: "English")
  projeto5.topics.create!(name: "5.3 Sonnet Poetry Parody", time: 1, unit: "English")
  projeto5.topics.create!(name: "5.3 Sonnet Poetry Parody - Let´s Check your Understanding!", time: 1, unit: "English")
  projeto5.topics.create!(name: "5.1 Energy Changes", time: 1, unit: "Science")
  projeto5.topics.create!(name: "5.2 Revisiting Acids and Alkalis", time: 1, unit: "Science")
  projeto5.topics.create!(name: "5.2 Acids and Alkalis — Let's Check your Understanding!", time: 1, unit: "Science")
  projeto5.topics.create!(name: "5.3 Reactivity Trends", time: 1, unit: "Science")
  projeto5.topics.create!(name: "5.3 Reactivity Trends — Let's Check your Understanding!", time: 1, unit: "Science")
  projeto5.topics.create!(name: "5.4 Reactivity Series", time: 1, unit: "Science")
  projeto5.topics.create!(name: "Project 5 — Let's Check your Understanding!", time: 1, unit: "Science")


  projeto6 = Subject.create!(
    name: "P6 - Clean Water and Sanitation - LWS Y9",
    category: :lws,
    )

  projeto6.topics.create!(name: "6.1 Introduction", time: 1, unit: "Learning Through Research")
  projeto6.topics.create!(name: "6.2 Clean Water", time: 1, unit: "Learning Through Research")
  projeto6.topics.create!(name: "6.3 Meet TIME's First-Ever Kid of the Year", time: 1, unit: "Learning Through Research")
  projeto6.topics.create!(name: "Clean Water Awareness Project - Let' s Check your Understanding!", time: 1, unit: "Learning Through Research")
  projeto6.topics.create!(name: "Let's Review and Learn - Polygons", time: 1, unit: "Maths")
  projeto6.topics.create!(name: "Polygons Quiz - Difficulty level: Low", time: 1, unit: "Maths")
  projeto6.topics.create!(name: "Let's Review and Learn - Units of Area, Volume and Capacity", time: 1, unit: "Maths")
  projeto6.topics.create!(name: "Metric units for Area,Volume and Capacity Quiz - Difficulty level: Low", time: 1, unit: "Maths")
  projeto6.topics.create!(name: "Let's Review and Learn - Circles, Sectors and Arcs", time: 1, unit: "Maths")
  projeto6.topics.create!(name: "Let's Learn and Watch - Area of a Circular Sector", time: 1, unit: "Maths")
  projeto6.topics.create!(name: "Sectors Quiz - Difficulty level: Low - Medium", time: 1, unit: "Maths")
  projeto6.topics.create!(name: "Let's Review and Learn - Areas and Compound Areas", time: 1, unit: "Maths")
  projeto6.topics.create!(name: "Areas and Compound Areas Quiz - Difficulty level: Low - Medium", time: 1, unit: "Maths")
  projeto6.topics.create!(name: "Let's Learn and Watch - Circle Theorems", time: 1, unit: "Maths")
  projeto6.topics.create!(name: "Circles Theorems - Difficulty level: Low - Medium", time: 1, unit: "Maths")
  projeto6.topics.create!(name: "Let's check your Understanding - Cross Topic Quiz Geometry 2D Shapes - Difficulty level: Medium", time: 1, unit: "Maths")
  projeto6.topics.create!(name: "6.1 Informative Writing (non-fiction)", time: 1, unit: "English")
  projeto6.topics.create!(name: "6.1 Informative Texts - Let´s Check your Understanding!", time: 1, unit: "English")
  projeto6.topics.create!(name: "6.2 Contrasting ideas", time: 1, unit: "English")
  projeto6.topics.create!(name: "6.2 Compare and Contrast - Let´s Check your Understanding!", time: 1, unit: "English")
  projeto6.topics.create!(name: "6.3 Story Openings", time: 1, unit: "English")
  projeto6.topics.create!(name: "6.3 Build a story! Let´s Check your Understanding!", time: 1, unit: "English")
  projeto6.topics.create!(name: "6.4 Story Endings", time: 1, unit: "English")
  projeto6.topics.create!(name: "6.4 A Story Ending - Let´s Check your Understanding!", time: 1, unit: "English")
  projeto6.topics.create!(name: "6.1 Funções Sintáticas: Modificadores", time: 1, unit: "Português")
  projeto6.topics.create!(name: "6.1 Funções Sintáticas: Modificadores  - Let's Check your Understanding!", time: 1, unit: "Português")
  projeto6.topics.create!(name: "6.2  Texto dramático", time: 1, unit: "Português")
  projeto6.topics.create!(name: "6.2 Let's Check your Understanding! - Texto dramático", time: 1, unit: "Português")
  projeto6.topics.create!(name: "6.3 Orações Coordenadas", time: 1, unit: "Português")
  projeto6.topics.create!(name: "6.3  - Let's Check your Understanding! Coordenação", time: 1, unit: "Português")
  projeto6.topics.create!(name: "6.1 Making Salts", time: 1, unit: "Science")
  projeto6.topics.create!(name: "6.1 Making Salts — Let's Check your Understanding!", time: 1, unit: "Science")
  projeto6.topics.create!(name: "6.2 Rates of Reaction", time: 1, unit: "Science")
  projeto6.topics.create!(name: "6.2 Rates of Reaction — Let's Check your Understanding!", time: 1, unit: "Science")
  projeto6.topics.create!(name: "6.3 Speeding Up Reactions", time: 1, unit: "Science")
  projeto6.topics.create!(name: "Project 6 — Let's Check your Understanding!", time: 1, unit: "Science")
  projeto6.topics.create!(name: "2nd Cross-Topic Practice — Let's Get Ready!", time: 1, unit: "Science")
  projeto6.topics.create!(name: "2nd Cross Topic — Let's Check Your Progress'", time: 1, unit: "Science")


  projeto7 = Subject.create!(
    name: "P7 - Gender Equality - LWS Y9",
    category: :lws,
    )

  projeto7.topics.create!(name: "7.1 Introduction", time: 1, unit: "Learning Through Research")
  projeto7.topics.create!(name: "7.2 Breaking the Cycle", time: 1, unit: "Learning Through Research")
  projeto7.topics.create!(name: "7.3 The Surfer Girls of Bangladesh", time: 1, unit: "Learning Through Research")
  projeto7.topics.create!(name: "Final Project: Break the Cycle - Let´s Check your Understanding!", time: 1, unit: "Learning Through Research")
  projeto7.topics.create!(name: "7.1 Orações Subordinadas substantivas", time: 1, unit: "Português")
  projeto7.topics.create!(name: "7.1 Orações Subordinadas substantivas — Let's Check your Understanding!", time: 1, unit: "Português")
  projeto7.topics.create!(name: "7.2 Orações Subordinadas adjetivas", time: 1, unit: "Português")
  projeto7.topics.create!(name: "7.2 Orações Subordinadas adjetivas — Let's Check your Understanding!", time: 1, unit: "Português")
  projeto7.topics.create!(name: "7.3 Orações Subordinadas adverbiais", time: 1, unit: "Português")
  projeto7.topics.create!(name: "7.3.1 Orações Subordinadas adverbiais — Let's Check your Understanding!", time: 1, unit: "Português")
  projeto7.topics.create!(name: "7.3.2 Orações Subordinadas adverbiais — Let's Check your Understanding!", time: 1, unit: "Português")
  projeto7.topics.create!(name: "7.1 Variation", time: 1, unit: "Science")
  projeto7.topics.create!(name: "7.1 Variation — Let's Debate!", time: 1, unit: "Science")
  projeto7.topics.create!(name: "7.2 Classification", time: 1, unit: "Science")
  projeto7.topics.create!(name: "7.2 Classification  — Let's Debate!", time: 1, unit: "Science")
  projeto7.topics.create!(name: "7.3 Adaptation", time: 1, unit: "Science")
  projeto7.topics.create!(name: "Project 7 — Let's Check your Understanding!", time: 1, unit: "Science")
  projeto7.topics.create!(name: "Let's Review and Learn - Volumes and Surface Area of a Cube and a Cuboid", time: 1, unit: "Maths")
  projeto7.topics.create!(name: "Volumes of Cuboids Quiz - Difficulty level: Low", time: 1, unit: "Maths")
  projeto7.topics.create!(name: "Let's Learn and Watch - Volumes and Surface Area of Prisms and Cylinders", time: 1, unit: "Maths")
  projeto7.topics.create!(name: "Volumes and Surface Area of Prisms and Cylinders - Difficulty level: Low - Medium", time: 1, unit: "Maths")
  projeto7.topics.create!(name: "Let's Learn and Watch - Volumes and Surface Area of Pyramids, Cones and Spheres", time: 1, unit: "Maths")
  projeto7.topics.create!(name: "Volumes and Surface Area of Pyramids, Cones and Spheres - Difficulty level: Low - Medium", time: 1, unit: "Maths")
  projeto7.topics.create!(name: "Let's Review and Learn  - Introduction to Vectors", time: 1, unit: "Maths")
  projeto7.topics.create!(name: "Vectors Quiz - Difficulty level: Low", time: 1, unit: "Maths")
  projeto7.topics.create!(name: "Let's Learn and Watch - Vectors: Magnitude and Scalar Multiplication", time: 1, unit: "Maths")
  projeto7.topics.create!(name: "Vectors:  Magnitude and Scalar Multiplication Quiz - Difficulty level: Low", time: 1, unit: "Maths")
  projeto7.topics.create!(name: "Let's Review and Learn - Transformations: Reflection
  s, Rotation and Translations", time: 1, unit: "Maths")
  projeto7.topics.create!(name: "Let's Learn and Watch -Transformations: Enlargements", time: 1, unit: "Maths")
  projeto7.topics.create!(name: "Transformations Quiz  - Difficulty level: Low - Medium", time: 1, unit: "Maths")
  projeto7.topics.create!(name: "Let's Practise - Question Bank I", time: 1, unit: "Maths")
  projeto7.topics.create!(name: "Let's Practise - Question Bank I Answers", time: 1, unit: "Maths")
  projeto7.topics.create!(name: "Let's Practise - Question Bank II", time: 1, unit: "Maths")
  projeto7.topics.create!(name: "Let's Practise - Question Bank II Answers", time: 1, unit: "Maths")
  projeto7.topics.create!(name: "Let's check your Understanding - Cross Topic Quiz Geometry 2D Shapes and 3D Solids - Difficulty Level: Medium", time: 1, unit: "Maths")
  projeto7.topics.create!(name: "Geometry Checkpoint", time: 1, unit: "Maths")
  projeto7.topics.create!(name: "7.1  The Tempest by William Shakespeare", time: 1, unit: "English")
  projeto7.topics.create!(name: "7.1 The Tempest  'Take Away Homework'- Let´s Check your Understanding!", time: 1, unit: "English")
  projeto7.topics.create!(name: "7.2 Making an Inference", time: 1, unit: "English")
  projeto7.topics.create!(name: "7.2 The Inference Wheel - Let´s Check your Understanding!", time: 1, unit: "English")
  projeto7.topics.create!(name: "7.3 When to Paragraph", time: 1, unit: "English")
  projeto7.topics.create!(name: "7.3 Reading aloud with Audacity - Let´s Check your Understanding!", time: 1, unit: "English")

    projeto8 = Subject.create!(
    name: "P8 - Reduced inequalities - LWS Y9",
    category: :lws,
    )


    projeto8.topics.create!(name: "8.1 Introduction", time: 1, unit: "Learning Through Research")
    projeto8.topics.create!(name: "8.2 What if the world had 100 people?", time: 1, unit: "Learning Through Research")
    projeto8.topics.create!(name: "8.3 The Forward and Background City", time: 1, unit: "Learning Through Research")
    projeto8.topics.create!(name: "Final Project: Reducing Inequality -Let´s Check your Understanding!", time: 1, unit: "Learning Through Research")
    projeto8.topics.create!(name: "8.1 IGCSE PREP: Cornell Note Taking", time: 1, unit: "English")
    projeto8.topics.create!(name: "8.1 Cornell Note-taking - Let´s Check your Understanding!", time: 1, unit: "English")
    projeto8.topics.create!(name: "8.2 How to Generate and Organise your Ideas", time: 1, unit: "English")
    projeto8.topics.create!(name: "8.2 The Time Traveller - Let´s Check your Understanding!", time: 1, unit: "English")
    projeto8.topics.create!(name: "8.3 Joseph Campbell´s Hero´s Journey", time: 1, unit: "English")
    projeto8.topics.create!(name: "8.3 Joseph Campbell´s Hero´s Journey and I - Let's Check your Understanding!", time: 1, unit: "English")
    projeto8.topics.create!(name: "Let's Practise - Probabilities", time: 1, unit: "Maths")
    projeto8.topics.create!(name: "Let's Practise - Relative Frequency Quiz", time: 1, unit: "Maths")
    projeto8.topics.create!(name: "Let's Practise - Two-way tables and Tree diagrams Quiz", time: 1, unit: "Maths")
    projeto8.topics.create!(name: "Let's Practise - Venn Diagram Quiz", time: 1, unit: "Maths")
    projeto8.topics.create!(name: "Let's Practise - Pie charts", time: 1, unit: "Maths")
    projeto8.topics.create!(name: "Let's Practise - Pictogram Quiz", time: 1, unit: "Maths")
    projeto8.topics.create!(name: "Let's Practise - Frequency Polygons Quiz", time: 1, unit: "Maths")
    projeto8.topics.create!(name: "Let's Practise - Scatter Graphs Quiz", time: 1, unit: "Maths")
    projeto8.topics.create!(name: "Let's Practise - Averages Quiz", time: 1, unit: "Maths")
    projeto8.topics.create!(name: "Let's Practise - Back to back Stem-and-Leaf Diagram Quiz", time: 1, unit: "Maths")
    projeto8.topics.create!(name: "Let's check your Understanding - Cross Topic Quiz Statistics", time: 1, unit: "Maths")
    projeto8.topics.create!(name: "Let's check your Understanding - Cross Topic Quiz Probability", time: 1, unit: "Maths")
    projeto8.topics.create!(name: "Mathematics Probability and Statistics Checkpoint", time: 1, unit: "Maths")
    projeto8.topics.create!(name: "8.1 Electrostatics", time: 1, unit: "Science")
    projeto8.topics.create!(name: "8.2 Intro to Electric Circuits", time: 1, unit: "Science")
    projeto8.topics.create!(name: "8.2 Electricity — Let's Collaborate: Glossary", time: 1, unit: "Science")
    projeto8.topics.create!(name: "8.3 More on Electric Circuits", time: 1, unit: "Science")
    projeto8.topics.create!(name: "Project 8 — Let's Check your Understanding!", time: 1, unit: "Science")
    projeto8.topics.create!(name: "8.4 Reduced inequalities — Let's Do Our Best!", time: 1, unit: "Science")
    projeto8.topics.create!(name: "8.1 Relação semântica entre palavras", time: 1, unit: "Português")
    projeto8.topics.create!(name: "8.1 Relação semântica entre palavras — Let's Check your Understanding!", time: 1, unit: "Português")
    projeto8.topics.create!(name: "8.2 Frase ativa e frase passiva", time: 1, unit: "Português")
    projeto8.topics.create!(name: "8.2 Frase ativa e frase passiva — Let's Check your Understanding!", time: 1, unit: "Português")
    projeto8.topics.create!(name: "8.3 Discurso direto e indireto", time: 1, unit: "Português")
    projeto8.topics.create!(name: "8.3 Discurso direto e indireto — Let's Check your Understanding!'", time: 1, unit: "Português")

    projeto9 = Subject.create!(
    name: "P9 - Partnerships for the Goals - LWS Y9",
    category: :lws,
    )

  projeto9.topics.create!(name: "9.1 Introduction", time: 1, unit: "Learning Through Research")
  projeto9.topics.create!(name: "9.2 Collaborating for Change: Partnerships", time: 1, unit: "Learning Through Research")
  projeto9.topics.create!(name: "9.3 Exploring The United Nations", time: 1, unit: "Learning Through Research")
  projeto9.topics.create!(name: "Final Project: The United Nations and Global Partnerships - Let´s Check your Understanding!", time: 1, unit: "Learning Through Research")
  projeto9.topics.create!(name: "9.1 Mystery Stories (Fiction)", time: 1, unit: "English")
  projeto9.topics.create!(name: "9.1 Mystery Short Story - Unraveling the Crime! - Let´s Check your Understanding!", time: 1, unit: "English")
  projeto9.topics.create!(name: "9.2 IGCSE PREP: Academic Report Writing (Non- fiction)", time: 1, unit: "English")
  projeto9.topics.create!(name: "9.2 Report Writing - Let´s Check your Understanding!", time: 1, unit: "English")
  projeto9.topics.create!(name: "9.3 All things Grammar!", time: 1, unit: "English")
  projeto9.topics.create!(name: "9.3 Action and Linking Verbs Song - Let´s Check your Understanding!", time: 1, unit: "English")
  projeto9.topics.create!(name: "9.1 Moments", time: 1, unit: "Science")
  projeto9.topics.create!(name: "9.2 Pressure", time: 1, unit: "Science")
  projeto9.topics.create!(name: "9.3 Density", time: 1, unit: "Science")
  projeto9.topics.create!(name: "Project 9 — Let's Check your Understanding!", time: 1, unit: "Science")
  projeto9.topics.create!(name: "Year 9 - Study Plan", time: 1, unit: "Science")
  projeto9.topics.create!(name: "Science — 100% Progression Test Submission", time: 1, unit: "Science")
  projeto9.topics.create!(name: "Numbers checkpoint - Unlimited Attempts", time: 1, unit: "Maths")
  projeto9.topics.create!(name: "Algebra checkpoint - Unlimited Attempts", time: 1, unit: "Maths")
  projeto9.topics.create!(name: "Geometry checkpoint - Unlimited Attempts", time: 1, unit: "Maths")
  projeto9.topics.create!(name: "Probability & Statistics checkpoint - Unlimited Attempts", time: 1, unit: "Maths")
  projeto9.topics.create!(name: "Let's Practise 100% Progression MODEL 1", time: 1, unit: "Maths")
  projeto9.topics.create!(name: "Let's Practise 100% Progression MODEL 2", time: 1, unit: "Maths")
  projeto9.topics.create!(name: "Mathematics Progression test Updated 2024", time: 1, unit: "Maths")
  projeto9.topics.create!(name: "9.1 Texto discursivo", time: 1, unit: "Português")
  projeto9.topics.create!(name: "9.1 Let's Check Your Understanding! - Texto Discursivo", time: 1, unit: "Português")
  projeto9.topics.create!(name: "9.2 Variação linguística", time: 1, unit: "Português")
  projeto9.topics.create!(name: "9.2 Let's Check Your Understanding! - Variação linguística", time: 1, unit: "Português")
  projeto9.topics.create!(name: "Português — Prova de Aferição'", time: 1, unit: "Português")


  project1 = Subject.create!(
    name: "P1 - Migration - LWS Y8",
    category: :lws,
    )

  project1.topics.create!(name: "1.1 What is a Short Story?", time: 1, unit: "English")
  project1.topics.create!(name: "1.2 Let's Have a Go at Reading!", time: 1, unit: "English")
  project1.topics.create!(name: "1.2 Let's have a go at reading! — Let's Check your Understanding!", time: 1, unit: "English")
  project1.topics.create!(name: "1.3 Elements of a Short Story", time: 1, unit: "English")
  project1.topics.create!(name: "1.4 Elements of a Plot", time: 1, unit: "English")
  project1.topics.create!(name: "1.4a) Freytag´s Pyramid in Marketing — Let's Check your Understanding!", time: 1, unit: "English")
  project1.topics.create!(name: "1.4b Analysis of  'Jack and the Beanstalk' using Freytag's Pyramid — Let's Check your Understanding!", time: 1, unit: "English")
  project1.topics.create!(name: "1.1 Food", time: 1, unit: "Science")
  project1.topics.create!(name: "1.1 Food Labels — Let's Check your Understanding! 🍭", time: 1, unit: "Science")
  project1.topics.create!(name: "1.2 Diet", time: 1, unit: "Science")
  project1.topics.create!(name: "1.2 Diet and Migration — Let's Debate! 🍭", time: 1, unit: "Science")
  project1.topics.create!(name: "1.3 Digestion", time: 1, unit: "Science")
  project1.topics.create!(name: "1.4 Enzymes", time: 1, unit: "Science")
  project1.topics.create!(name: "Project 1 — Let's Check your Understanding! 🍭", time: 1, unit: "Science")
  project1.topics.create!(name: "1.1 Textos dos Media e Quotidiano: A Reportagem", time: 1, unit: "Português")
  project1.topics.create!(name: "1.1 Vamos gravar uma reportagem? — Let's Check your Understanding!", time: 1, unit: "Português")
  project1.topics.create!(name: "1.2 Notícia, para que te quero?", time: 1, unit: "Português")
  project1.topics.create!(name: "1.3 Fake News! Notícias Falsas!", time: 1, unit: "Português")
  project1.topics.create!(name: "1.3 Reduz a Circulação de Notícias Falsas — Let's Check your Understanding!", time: 1, unit: "Português")
  project1.topics.create!(name: "1.1 Understanding Migration", time: 1, unit: "Learning Through Research")
  project1.topics.create!(name: "1.2 Migrant vs Refugees", time: 1, unit: "Learning Through Research")
  project1.topics.create!(name: "1.3 A Refugee's Journey!", time: 1, unit: "Learning Through Research")
  project1.topics.create!(name: "Final Project — Let's Check your Understanding!", time: 1, unit: "Learning Through Research")
  project1.topics.create!(name: "Let´s Reflect! Let's Check your Understanding!", time: 1, unit: "Learning Through Research")
  project1.topics.create!(name: "Let's Learn - Exploring Number Hierarchies and Negative Numbers", time: 1, unit: "Maths")
  project1.topics.create!(name: "Let's Watch", time: 1, unit: "Maths")
  project1.topics.create!(name: "Multiplying and Dividing Negative Numbers — Let's Practise", time: 1, unit: "Maths")
  project1.topics.create!(name: "Let's Learn - Prime Factors, HCF and LCM", time: 1, unit: "Maths")
  project1.topics.create!(name: "Let's Watch", time: 1, unit: "Maths")
  project1.topics.create!(name: "Prime Factors, HCF and LCM — Let's Practise", time: 1, unit: "Maths")
  project1.topics.create!(name: "Let's Learn - Square and Cube Numbers", time: 1, unit: "Maths")
  project1.topics.create!(name: "Let's Watch", time: 1, unit: "Maths")
  project1.topics.create!(name: "Square and Cube Numbers — Let's Practise", time: 1, unit: "Maths")
  project1.topics.create!(name: "Let's Learn - Fractions", time: 1, unit: "Maths")
  project1.topics.create!(name: "Let's Watch", time: 1, unit: "Maths")
  project1.topics.create!(name: "Equivalent Fractions and Simplification — Let's Practise", time: 1, unit: "Maths")
  project1.topics.create!(name: "Let's Learn - Adding and Subtracting Fractions", time: 1, unit: "Maths")
  project1.topics.create!(name: "Let's Watch", time: 1, unit: "Maths")
  project1.topics.create!(name: "Adding and Subtracting Fractions and Calculating with Mixed Numbers Quiz — Let's Practise", time: 1, unit: "Maths")
  project1.topics.create!(name: "Let's Learn - Multiplying and Dividing Fractions", time: 1, unit: "Maths")
  project1.topics.create!(name: "Let's Watch", time: 1, unit: "Maths")
  project1.topics.create!(name: "Multiplying and Dividing Fractions Quiz — Let's Practise", time: 1, unit: "Maths")
  project1.topics.create!(name: "Let's Check your Understanding - Cross Topic Practise Quiz on Numbers", time: 1, unit: "Maths")

  project2 = Subject.create!(
    name: "P2 - Peace, Justice and Strong Institutions - LWS Y8",
    category: :lws,
    )

  project2.topics.create!(name: "2.1 Building a Fictional Character", time: 1, unit: "English")
  project2.topics.create!(name: "2.1 Exploring Characters — Let's Check your Understanding", time: 1, unit: "English")
  project2.topics.create!(name: "2.2 Characterisation", time: 1, unit: "English")
  project2.topics.create!(name: "2.2 Identifying Direct and Indirect Characterisation — Let's Check your Understanding", time: 1, unit: "English")
  project2.topics.create!(name: "2.2 Extra Practice  — Let's Check your Understanding", time: 1, unit: "English")
  project2.topics.create!(name: "2.3 Building your Own Villain Character", time: 1, unit: "English")
  project2.topics.create!(name: "2.3 Building your own Villain — Let's Check your Understanding", time: 1, unit: "English")
  project2.topics.create!(name: "2.4 Immigrant Character", time: 1, unit: "English")
  project2.topics.create!(name: "2.4 Immigrant Character — Let's Check your Understanding", time: 1, unit: "English")
  project2.topics.create!(name: "2.1 Introduction to SDG 16", time: 1, unit: "Learning Through Research")
  project2.topics.create!(name: "2.1 SDG 16 and the Human Rights' BINGO! — Let's Check your Understanding", time: 1, unit: "Learning Through Research")
  project2.topics.create!(name: "2.2 SDG 16.2 Child Labour", time: 1, unit: "Learning Through Research")
  project2.topics.create!(name: "2.2 Clay or Origami peace doves — Let's Check your Understanding", time: 1, unit: "Learning Through Research")
  project2.topics.create!(name: "2.3 The Power of Peace", time: 1, unit: "Learning Through Research")
  project2.topics.create!(name: "2.3 Reflection on SDG 16 — Let's Check your Understanding", time: 1, unit: "Learning Through Research")
  project2.topics.create!(name: "Let's Learn - Decimals: Rounding and Converting Fractions to Decimals", time: 1, unit: "Mathematics")
  project2.topics.create!(name: "Let's Watch - Decimals", time: 1, unit: "Mathematics")
  project2.topics.create!(name: "Rounding Decimals Quiz — Let's Practise", time: 1, unit: "Mathematics")
  project2.topics.create!(name: "Converting Fractions to Decimals Quiz — Let's Practise", time: 1, unit: "Mathematics")
  project2.topics.create!(name: "Let's Learn - Decimals: Multiplying and Dividing", time: 1, unit: "Mathematics")
  project2.topics.create!(name: "Let's Watch - Decimals", time: 1, unit: "Mathematics")
  project2.topics.create!(name: "Multiplying and Dividing Decimals Quiz — Let's Practise", time: 1, unit: "Mathematics")
  project2.topics.create!(name: "Let's Learn - Percentages", time: 1, unit: "Mathematics")
  project2.topics.create!(name: "Let's Learn - Percentages Changes", time: 1, unit: "Mathematics")
  project2.topics.create!(name: "Let's Watch - Percentages", time: 1, unit: "Mathematics")
  project2.topics.create!(name: "Writing Percentages Quiz — Let's Practise", time: 1, unit: "Mathematics")
  project2.topics.create!(name: "Equivalent Fractions, Decimals and Percentages Quiz — Let's Practise", time: 1, unit: "Mathematics")
  project2.topics.create!(name: "Percentage of Amounts Quiz — Let's Practise", time: 1, unit: "Mathematics")
  project2.topics.create!(name: "Word Problems Percentages — Let's Practise", time: 1, unit: "Mathematics")
  project2.topics.create!(name: "Let's Learn - Ratios", time: 1, unit: "Mathematics")
  project2.topics.create!(name: "Ratios Quiz — Let's Practise", time: 1, unit: "Mathematics")
  project2.topics.create!(name: "Quiz Working with Ratios — Let's Practise", time: 1, unit: "Mathematics")
  project2.topics.create!(name: "Word Problems Ratios — Let's Practise", time: 1, unit: "Mathematics")
  project2.topics.create!(name: "Let's Check your Understanding - Cross Topic Quiz Fractions, Decimals, Ratio and Proportion", time: 1, unit: "Mathematics")
  project2.topics.create!(name: "2.1 Textos Informativos", time: 1, unit: "Português")
  project2.topics.create!(name: "2.1 Texto Informativo sobre Imigração em Portugal — Let's Check your Understanding", time: 1, unit: "Português")
  project2.topics.create!(name: "2.2 Banda Desenhada", time: 1, unit: "Português")
  project2.topics.create!(name: "2.2 Banda Desenhada — Let's Check your Understanding", time: 1, unit: "Português")
  project2.topics.create!(name: "2.3 Carta Formal & Informal", time: 1, unit: "Português")
  project2.topics.create!(name: "2.3 Escreve uma carta formal ✉️ — Let's Check your Understanding", time: 1, unit: "Português")
  project2.topics.create!(name: "2.4 Chats e Blogs", time: 1, unit: "Português")
  project2.topics.create!(name: "2.4 Aplicações de Chat — Let's Check your Understanding I", time: 1, unit: "Português")
  project2.topics.create!(name: "2.4 O meu blog — Let's Check your Understanding", time: 1, unit: "Português")
  project2.topics.create!(name: "2.1 Atoms and Elements", time: 1, unit: "Science")
  project2.topics.create!(name: "2.1 Organising Information in Science — Let's Debate!", time: 1, unit: "Science")
  project2.topics.create!(name: "2.2 Organising the Elements", time: 1, unit: "Science")
  project2.topics.create!(name: "2.2 The Search for New Elements — Let's Check your Understanding!", time: 1, unit: "Science")

  project3 = Subject.create!(
    name: "P3 - Climate Action - LWS Y8",
    category: :lws,
    )

  project3.topics.create!(name: "3.1 Compounds", time: 1, unit: "Science")
  project3.topics.create!(name: "3.1 Compounds and Climate Action — Let's Check your Understanding!", time: 1, unit: "Science")
  project3.topics.create!(name: "3.1 Montréal Protocol  — Let's Debate!", time: 1, unit: "Science")
  project3.topics.create!(name: "3.2 Making Compounds", time: 1, unit: "Science")
  project3.topics.create!(name: "3.3 Mixtures", time: 1, unit: "Science")
  project3.topics.create!(name: "Project 3 — Let's Check your Understanding!", time: 1, unit: "Science")
  project3.topics.create!(name: "1st Cross-Topic Practice — Let's Get Ready!", time: 1, unit: "Science")
  project3.topics.create!(name: "1st Cross-Topic Assessment — Let's Check your Progress", time: 1, unit: "Science")
  project3.topics.create!(name: "3.1 Taking Action!", time: 1, unit: "Learning Through Research")
  project3.topics.create!(name: "3.2 Clean Water!", time: 1, unit: "Learning Through Research")
  project3.topics.create!(name: "3.3 Reuse, Repair and Repurpose!", time: 1, unit: "Learning Through Research")
  project3.topics.create!(name: "3.4  Art and Climate Change", time: 1, unit: "Learning Through Research")
  project3.topics.create!(name: "Final Project: Art and Climate Change: Let´s Check your Understanding!", time: 1, unit: "Learning Through Research")
  project3.topics.create!(name: "3.1 Textos Narrativos", time: 1, unit: "Português")
  project3.topics.create!(name: "3.1 Releitura → Let's Check your Understanding", time: 1, unit: "Português")
  project3.topics.create!(name: "3.2 Lenda", time: 1, unit: "Português")
  project3.topics.create!(name: "3.2 Lenda → Let's Check your Understanding!", time: 1, unit: "Português")
  project3.topics.create!(name: "3.3 Conto", time: 1, unit: "Português")
  project3.topics.create!(name: "3.3 Conto → Let's Check your Understanding", time: 1, unit: "Português")
  project3.topics.create!(name: "3.4 Fábulas", time: 1, unit: "Português")
  project3.topics.create!(name: "3.4 Fábula → Let's Check your Understanding!", time: 1, unit: "Português")
  project3.topics.create!(name: "3.1 Persuasive Writing", time: 1, unit: "English")
  project3.topics.create!(name: "3.1 Persuasion in Advertisement — Let's Check your Understanding!", time: 1, unit: "English")
  project3.topics.create!(name: "3.2 Emotive Writing", time: 1, unit: "English")
  project3.topics.create!(name: "3.2. Emotive Writing — Let's Check your Understanding!", time: 1, unit: "English")
  project3.topics.create!(name: "3.3 Modal Verbs in Persuasive Language", time: 1, unit: "English")
  project3.topics.create!(name: "3.3 Let´s Save an Island! — Let's Check your Understanding!", time: 1, unit: "English")
  project3.topics.create!(name: "3.4 Rhetorical Questions in Persuasive Language", time: 1, unit: "English")
  project3.topics.create!(name: "3.4 Rhetorical Questions — Let's Check your Understanding!", time: 1, unit: "English")
  project3.topics.create!(name: "Let's Learn - Introduction to Algebra", time: 1, unit: "Mathematics")
  project3.topics.create!(name: "Let's Watch - Introduction to Algebra", time: 1, unit: "Mathematics")
  project3.topics.create!(name: "Let's Watch -  Simplifying expressions", time: 1, unit: "Mathematics")
  project3.topics.create!(name: "Let's Practise - Simplifying Expressions Quiz", time: 1, unit: "Mathematics")
  project3.topics.create!(name: "Let's Learn - Formulas", time: 1, unit: "Mathematics")
  project3.topics.create!(name: "Let's Watch - Substituting into Expressions", time: 1, unit: "Mathematics")
  project3.topics.create!(name: "Let's Practise - Substituting into Expressions Part II Quiz", time: 1, unit: "Mathematics")
  project3.topics.create!(name: "Let's Practise - Substituting into Formulas Quiz", time: 1, unit: "Mathematics")
  project3.topics.create!(name: "Let's Watch -  Solving equations", time: 1, unit: "Mathematics")
  project3.topics.create!(name: "Let's Practise - Solving One Step Equations Quiz", time: 1, unit: "Mathematics")
  project3.topics.create!(name: "Let's Practise - Solving Equations Quiz", time: 1, unit: "Mathematics")
  project3.topics.create!(name: "Let's Practise - Solving Equations with Formulae Quiz", time: 1, unit: "Mathematics")
  project3.topics.create!(name: "Let's Practise - Solving Multi Step Equations Quiz", time: 1, unit: "Mathematics")
  project3.topics.create!(name: "Let's Learn - Expanding Expressions", time: 1, unit: "Mathematics")
  project3.topics.create!(name: "Let's Watch - Expanding Expressions", time: 1, unit: "Mathematics")
  project3.topics.create!(name: "Let's Practise - Expanding Expressions Quiz", time: 1, unit: "Mathematics")
  project3.topics.create!(name: "Let's Check your understanding - Cross Topic Quiz Expressions, Equations and Formulas", time: 1, unit: "Mathematics")


  project4 = Subject.create!(
    name: "P4 - Responsible Consumption and Production - LWS Y8",
    category: :lws,
    )

  project4.topics.create!(name: "4.1 Chemical Reactions", time: 1, unit: "Science")
  project4.topics.create!(name: "4.2 Minerals", time: 1, unit: "Science")
  project4.topics.create!(name: "4.3 Identifying Ions", time: 1, unit: "Science")
  project4.topics.create!(name: "Project 4 — Let's Check your Understanding!", time: 1, unit: "Science")
  project4.topics.create!(name: "Let's Collaborate: Science Notes", time: 1, unit: "Science")
  project4.topics.create!(name: "Science — 50% Progression Test Submission", time: 1, unit: "Science")
  project4.topics.create!(name: "4.1 Introduction", time: 1, unit: "Learning Through Research")
  project4.topics.create!(name: "4.1 Your Ecological Footprint - Let´s Check your Understanding!", time: 1, unit: "Learning Through Research")
  project4.topics.create!(name: "4.2 Fast Fashion", time: 1, unit: "Learning Through Research")
  project4.topics.create!(name: "4.2 To wear or not to wear! Let´s Check your Understanding!", time: 1, unit: "Learning Through Research")
  project4.topics.create!(name: "4.3 Food Waste", time: 1, unit: "Learning Through Research")
  project4.topics.create!(name: "4.3 Top Leftover Chef - Let´s Check your Understanding!", time: 1, unit: "Learning Through Research")
  project4.topics.create!(name: "4.1 Introduction: The Giver", time: 1, unit: "English")
  project4.topics.create!(name: "4.2 Utopian and Dystopian Societies", time: 1, unit: "English")
  project4.topics.create!(name: "4.3 Let´s get down to reading!", time: 1, unit: "English")
  project4.topics.create!(name: "Final Graded Assignment: Discovering 'The Giver'! - Let´s Check your Understanding!", time: 1, unit: "English")
  project4.topics.create!(name: "English — 50% Progression Test Request", time: 1, unit: "English")
  project4.topics.create!(name: "Project 4 Progression Test Study Guide", time: 1, unit: "English")
  project4.topics.create!(name: "English — 50% Progression Test Submission", time: 1, unit: "English")
  project4.topics.create!(name: "Let's Learn - Graphs Science", time: 1, unit: "Mathematics")
  project4.topics.create!(name: "Let's Learn - Graphs in Maths - Distance-Time Graphs", time: 1, unit: "Mathematics")
  project4.topics.create!(name: "Let's Learn - Graphs in SDG's", time: 1, unit: "Mathematics")
  project4.topics.create!(name: "Let's Watch - Graphs", time: 1, unit: "Mathematics")
  project4.topics.create!(name: "Let's Practise - Distance-time Graphs Quiz", time: 1, unit: "Mathematics")
  project4.topics.create!(name: "Let's Learn - Linear Graphs", time: 1, unit: "Mathematics")
  project4.topics.create!(name: "Let's Practise - Quiz Plotting Linear Graphs", time: 1, unit: "Mathematics")
  project4.topics.create!(name: "Let's Learn - Gradient", time: 1, unit: "Mathematics")
  project4.topics.create!(name: "Let's Explore - Interactive Gradient (Slopes)", time: 1, unit: "Mathematics")
  project4.topics.create!(name: "Let's Practise - Quiz The Gradient", time: 1, unit: "Mathematics")
  project4.topics.create!(name: "Let's Learn - Equation of a straight line", time: 1, unit: "Mathematics")
  project4.topics.create!(name: "Let's Explore - Interactive Equation of the Straight Line", time: 1, unit: "Mathematics")
  project4.topics.create!(name: "Let's Practise - Quiz of the Straight-line Equation", time: 1, unit: "Mathematics")
  project4.topics.create!(name: "Let's Learn - System of Simultaneous Equations", time: 1, unit: "Mathematics")
  project4.topics.create!(name: "Let's Practise - Simultaneous Equations", time: 1, unit: "Mathematics")
  project4.topics.create!(name: "Let's Check your understanding - Cross-Topic", time: 1, unit: "Mathematics")
  project4.topics.create!(name: "Year 8 Study Plan 50% Progression test", time: 1, unit: "Mathematics")
  project4.topics.create!(name: "Mathematics — 50% Progression Test Model", time: 1, unit: "Mathematics")
  project4.topics.create!(name: "Mathematics — 50% Progression Test", time: 1, unit: "Mathematics")
  project4.topics.create!(name: "4.1 Classe de Palavras: Nomes e Adjetivos", time: 1, unit: "Português")
  project4.topics.create!(name: "4.1.1 Classe de Palavras: Nomes e Adjetivos -  Let's Check your Understanding", time: 1, unit: "Português")
  project4.topics.create!(name: "4.1.2 Classe de Palavras: Nomes e Adjetivos - Let's Check your Understanding", time: 1, unit: "Português")
  project4.topics.create!(name: "4.2 Classe de Palavras: Pronomes e Determinantes", time: 1, unit: "Português")
  project4.topics.create!(name: "4.2 Classe de Palavras: Pronomes e Determinantes - Let's Check your Understanding 1", time: 1, unit: "Português")
  project4.topics.create!(name: "4.3: Classe de Palavras: Interjeição, Conjunção e Quantificadores", time: 1, unit: "Português")
  project4.topics.create!(name: "4.3.1 Classe de Palavras: Interjeição, Conjunção e Qualificadores. - Let's Check your Understanding", time: 1, unit: "Português")
  project4.topics.create!(name: "4.3.2 Classe de Palavras: Interjeição, Conjunção e Quantificadores. - Let's Check your Understanding", time: 1, unit: "Português")
  project4.topics.create!(name: "4.4 Classe de Palavras: Verbos, Advérbios e Preposições.", time: 1, unit: "Português")
  project4.topics.create!(name: "4.4 Classe de Palavras: Verbos, Advérbios e Preposições. - Let's Check your Understanding", time: 1, unit: "Português")

  project5 = Subject.create!(
    name: "P5 - Life Below Water - LWS Y8",
    category: :lws,
    )

    project5.topics.create!(name: "5.1 Introduction", time: 1, unit: "Learning Through Research")
    project5.topics.create!(name: "5.2 What is happening to the fish?", time: 1, unit: "Learning Through Research")
    project5.topics.create!(name: "5.3 Coral Reef Crusaders!", time: 1, unit: "Learning Through Research")
    project5.topics.create!(name: "Final Project: Ocean Advocates' Creative Challenge - Let´s Check your Understanding!", time: 1, unit: "Learning Through Research")
    project5.topics.create!(name: "5.1 Biografia", time: 1, unit: "Português")
    project5.topics.create!(name: "5.1 Let's Check Your Understanding! - Biografia", time: 1, unit: "Português")
    project5.topics.create!(name: "5.2 Processo de formação de palavras", time: 1, unit: "Português")
    project5.topics.create!(name: "5.2 Let's Check Your Understanding! - Processo de formação de palavras", time: 1, unit: "Português")
    project5.topics.create!(name: "5.3 Comparação e Interpretação entre textos.", time: 1, unit: "Português")
    project5.topics.create!(name: "5.3 Let's Check Your Understanding! - Comparação e Interpretação entre textos.", time: 1, unit: "Português")
    project5.topics.create!(name: "5.4 Organização textual e sinais de pontuação", time: 1, unit: "Português")
    project5.topics.create!(name: "5.4.1 Let's Check Your Understanding! - Organização textual e sinais de pontuação", time: 1, unit: "Português")
    project5.topics.create!(name: "5.4.2 Let's Check Your Understanding! - Organização textual e sinais de pontuação", time: 1, unit: "Português")
    project5.topics.create!(name: "5.1 States of Matter", time: 1, unit: "Science")
    project5.topics.create!(name: "5.1 States of Matter — Let's Check your Understanding!", time: 1, unit: "Science")
    project5.topics.create!(name: "5.2 Explaining Processes with the Particle Theory", time: 1, unit: "Science")
    project5.topics.create!(name: "5.2 Explaining Processes with the Particle Theory — Let's Check your Understanding!", time: 1, unit: "Science")
    project5.topics.create!(name: "5.3 Sound", time: 1, unit: "Science")
    project5.topics.create!(name: "Project 5 — Let's Check your Understanding!", time: 1, unit: "Science")
    project5.topics.create!(name: "Let's Learn - Geometry", time: 1, unit: "Mathematics")
    project5.topics.create!(name: "Let's Learn and Watch - Angles and Lines", time: 1, unit: "Mathematics")
    project5.topics.create!(name: "Let's Learn and Watch - Measuring and Drawing Angles", time: 1, unit: "Mathematics")
    project5.topics.create!(name: "Geometry, Angles and Lines Quiz - Difficulty level: Low", time: 1, unit: "Mathematics")
    project5.topics.create!(name: "Missing Angles Quiz - Difficulty level: Low", time: 1, unit: "Mathematics")
    project5.topics.create!(name: "Let's Learn and Watch - Angles in Triangles", time: 1, unit: "Mathematics")
    project5.topics.create!(name: "Angles in Triangles Quiz - Difficulty level: Low", time: 1, unit: "Mathematics")
    project5.topics.create!(name: "Angles, Triangles and Lines Quiz - Difficulty level: Low", time: 1, unit: "Mathematics")
    project5.topics.create!(name: "Let's Learn and Watch - Quadrilaterals", time: 1, unit: "Mathematics")
    project5.topics.create!(name: "Geometric Properties of Quadrilaterals Quiz - Difficulty level: Low", time: 1, unit: "Mathematics")
    project5.topics.create!(name: "Let's check your understanding - Shapes and Angles Cross Topic Quiz - Difficulty level: Medium", time: 1, unit: "Mathematics")
    project5.topics.create!(name: "5.1 Gothic Literature", time: 1, unit: "English")
    project5.topics.create!(name: "5.1 Gothic Literature - Let´s Check your Understanding!", time: 1, unit: "English")
    project5.topics.create!(name: "5.2 Tone, Mood and Atmosphere", time: 1, unit: "English")
    project5.topics.create!(name: "5.2 Tone, Mood and Atmosphere - Let´s Check your Understanding!!", time: 1, unit: "English")
    project5.topics.create!(name: "5.3 Types of Conflict", time: 1, unit: "English")
    project5.topics.create!(name: "5.3 Types of Conflict - Let's Check your Understanding!", time: 1, unit: "English")
    project5.topics.create!(name: "5.4 Figurative Language in Writing", time: 1, unit: "English")
    project5.topics.create!(name: "5.4 Photo Figurative Language - Let´s Check your Understanding!", time: 1, unit: "English")

  project6 = Subject.create!(
    name: "P6 - Quality Education - LWS Y8",
    category: :lws,
    )

  project6.topics.create!(name: "6.1 Circulation", time: 1, unit: "Science")
  project6.topics.create!(name: "6.1 Circulation — Let's Check your Understanding!", time: 1, unit: "Science")
  project6.topics.create!(name: "6.2 Need for Speed", time: 1, unit: "Science")
  project6.topics.create!(name: "6.2 Need for Speed — Let's Check your Understanding!", time: 1, unit: "Science")
  project6.topics.create!(name: "6.3 Forces", time: 1, unit: "Science")
  project6.topics.create!(name: "Project 6 — Let's Check your Understanding!", time: 1, unit: "Science")
  project6.topics.create!(name: "2nd Cross-Topic Practice — Let's Get Ready!", time: 1, unit: "Science")
  project6.topics.create!(name: "2nd Cross-Topic — Let's Check Your Progress", time: 1, unit: "Science")
  project6.topics.create!(name: "Let's Learn and Watch - Polygons", time: 1, unit: "Mathematics")
  project6.topics.create!(name: "Polygons Quiz - Difficulty level: Low", time: 1, unit: "Mathematics")
  project6.topics.create!(name: "Let's Learn and Watch - Units of Area, Volume and Capacity", time: 1, unit: "Mathematics")
  project6.topics.create!(name: "Metric units for Area,Volume and Capacity Quiz - Difficulty level: Low", time: 1, unit: "Mathematics")
  project6.topics.create!(name: "Let's Learn and Watch - Circles, Sectors and Arcs", time: 1, unit: "Mathematics")
  project6.topics.create!(name: "Circles, Sectors and Arcs Quiz - Difficulty level: Low", time: 1, unit: "Mathematics")
  project6.topics.create!(name: "Let's Learn and Watch - Perimeter", time: 1, unit: "Mathematics")
  project6.topics.create!(name: "Perimeter Quiz - Difficulty level: Low", time: 1, unit: "Mathematics")
  project6.topics.create!(name: "Let's Learn and Watch- Areas and Compound Areas", time: 1, unit: "Mathematics")
  project6.topics.create!(name: "Areas and Compound Areas Quiz - Difficulty level: Low - Medium", time: 1, unit: "Mathematics")
  project6.topics.create!(name: "Let's check your Understanding - Cross Topic Quiz Geometry 2D Shapes - Difficulty level: Medium", time: 1, unit: "Mathematics")
  project6.topics.create!(name: "6.1 A look into the future...", time: 1, unit: "English")
  project6.topics.create!(name: "6.1 Planning and Writing a Story Opening - Let´s Check your Understanding!", time: 1, unit: "English")
  project6.topics.create!(name: "6.2 The power of a good argument!", time: 1, unit: "English")
  project6.topics.create!(name: "6.2 Newspaper Article - Let´s Check your Understanding!", time: 1, unit: "English")
  project6.topics.create!(name: "6.3 Punctuation: Why do I need you?", time: 1, unit: "English")
  project6.topics.create!(name: "6.3 Punctuation Pyramid - Let´s Check your Understanding!", time: 1, unit: "English")
  project6.topics.create!(name: "6.1 Texto poético", time: 1, unit: "Português")
  project6.topics.create!(name: "6.1.1 Texto poético — Let's Check Your Understanding!", time: 1, unit: "Português")
  project6.topics.create!(name: "6.1.2 Texto poético — Let's Check Your Understanding!", time: 1, unit: "Português")
  project6.topics.create!(name: "6.2 Registo e tratamento de informações", time: 1, unit: "Português")
  project6.topics.create!(name: "6.2.1 Registo e tratamento de informações — Let's Check Your Understanding!", time: 1, unit: "Português")
  project6.topics.create!(name: "6.2.2 Registo e tratamento de informações — Let's Check Your Understanding!", time: 1, unit: "Português")
  project6.topics.create!(name: "6.3 Funções sintáticas: Sujeito, vocativo e predicado", time: 1, unit: "Português")
  project6.topics.create!(name: "6.3 Funções sintáticas: Sujeito, vocativo e predicado — Let's Check Your Understanding!", time: 1, unit: "Português")
  project6.topics.create!(name: "6.1 Introduction", time: 1, unit: "Learning Through Research")
  project6.topics.create!(name: "6.2 Lessons for Life", time: 1, unit: "Learning Through Research")
  project6.topics.create!(name: "6.3 Why are so many kids still not in school?", time: 1, unit: "Learning Through Research")
  project6.topics.create!(name: "Final Project: Dear Gudiya... - Let´s Check your Understanding", time: 1, unit: "Learning Through Research")

  project7 = Subject.create!(
    name: "P7 - Industry, Innovation and Infrastructure - LWS Y8",
    category: :lws,
    )

  project7.topics.create!(name: "7.1 Introduction", time: 1, unit: "Learning Through Research")
  project7.topics.create!(name: "7.2 Sustainable Mobility", time: 1, unit: "Learning Through Research")
  project7.topics.create!(name: "7.3 Stop Disasters", time: 1, unit: "Learning Through Research")
  project7.topics.create!(name: "7.3 Your 'Beat the Flood' Challenge - Let´s Check your Understanding!", time: 1, unit: "Learning Through Research")
  project7.topics.create!(name: "7.1 Funções sintáticas: Complemento direto", time: 1, unit: "Português")
  project7.topics.create!(name: "7.1 Let's Check your Understanding!  - Funções sintáticas: Complemento direto", time: 1, unit: "Português")
  project7.topics.create!(name: "7.2 Funções sintáticas: Complemento indireto e oblíquo", time: 1, unit: "Português")
  project7.topics.create!(name: "7.2 Let's Check your Understanding! - Funções sintáticas: Complemento indireto e oblíquo", time: 1, unit: "Português")
  project7.topics.create!(name: "7.3 Funções sintáticas: Complemento agente da passiva", time: 1, unit: "Português")
  project7.topics.create!(name: "7.3 Let's Check your Understanding! - Funções sintáticas: Complemento agente da passiva e Predicativo de Sujeito", time: 1, unit: "Português")
  project7.topics.create!(name: "7.1 Light", time: 1, unit: "Science")
  project7.topics.create!(name: "7.1 Light — Let's Debate!", time: 1, unit: "Science")
  project7.topics.create!(name: "7.2 Colour", time: 1, unit: "Science")
  project7.topics.create!(name: "7.2 Colour — Let's Debate!", time: 1, unit: "Science")
  project7.topics.create!(name: "7.3 Magnetism", time: 1, unit: "Science")
  project7.topics.create!(name: "Project 7 — Let's Check your Understanding!", time: 1, unit: "Science")
  project7.topics.create!(name: "Let's Learn and Watch - Volumes and Surface Area of a Cube and a Cuboid", time: 1, unit: "Mathematics")
  project7.topics.create!(name: "Volumes of Cuboids Quiz - Difficulty level: Low", time: 1, unit: "Mathematics")
  project7.topics.create!(name: "Let's Learn and Watch - Introduction to Vectors", time: 1, unit: "Mathematics")
  project7.topics.create!(name: "Vectors Quiz - Difficulty level: Low", time: 1, unit: "Mathematics")
  project7.topics.create!(name: "Let's Learn and Watch - Introduction to Transformations", time: 1, unit: "Mathematics")
  project7.topics.create!(name: "Transformations Quiz  - Difficulty level: Low - Medium", time: 1, unit: "Mathematics")
  project7.topics.create!(name: "Let's check your Understanding - Cross Topic Quiz Geometry 2D Shapes and 3D Solids - Difficulty Level: Medium", time: 1, unit: "Mathematics")
  project7.topics.create!(name: "7.1 Drama! Curtain up!", time: 1, unit: "English")
  project7.topics.create!(name: "7.1 Drama! Curtain up! - Let´s Check your Understanding!", time: 1, unit: "English")
  project7.topics.create!(name: "7.2 Setting out a Script", time: 1, unit: "English")
  project7.topics.create!(name: "7.2 Writing an opening scene - Let´s Check your Understanding!", time: 1, unit: "English")
  project7.topics.create!(name: "7.3 Shakespeare's Language", time: 1, unit: "English")
  project7.topics.create!(name: "7.3 Putting Pen to Paper  - Let's Check your Understanding!", time: 1, unit: "English")
  project7.topics.create!(name: "7.1 Customs and Traditions: Clothing", time: 1, unit: "English")


  project8 = Subject.create!(
    name: "P8 - Sustainable Cities and Communities - LWS Y8",
    category: :lws,
    )

    project8.topics.create!(name: "8.1 Introduction", time: 1, unit: "Learning Through Research")
    project8.topics.create!(name: "8.2 Sustainable Cities", time: 1, unit: "Learning Through Research")
    project8.topics.create!(name: "8.3 When a House is not a Home", time: 1, unit: "Learning Through Research")
    project8.topics.create!(name: "Final Project: Minecraft Sustainable City - Let´s Check your Understanding!", time: 1, unit: "Learning Through Research")
    project8.topics.create!(name: "8.1 Predicativo do sujeito", time: 1, unit: "Português")
    project8.topics.create!(name: "8.1 Let's Check Your Understanding! - Predicativo do sujeito", time: 1, unit: "Português")
    project8.topics.create!(name: "8.2 Modificadores", time: 1, unit: "Português")
    project8.topics.create!(name: "8.2 Let's Check Your Understanding! -  Modificadores", time: 1, unit: "Português")
    project8.topics.create!(name: "8.3 Frase simples e frase complexa", time: 1, unit: "Português")
    project8.topics.create!(name: "8.1 Reproduction", time: 1, unit: "Science")
    project8.topics.create!(name: "8.1 Reproduction — Let's Collaborate: Glossary", time: 1, unit: "Science")
    project8.topics.create!(name: "8.2 Foetal Development", time: 1, unit: "Science")
    project8.topics.create!(name: "8.3 Puberty", time: 1, unit: "Science")
    project8.topics.create!(name: "Project 8 — Let's Check your Understanding!", time: 1, unit: "Science")
    project8.topics.create!(name: "8.1 An introduction to Poetry", time: 1, unit: "English")
    project8.topics.create!(name: "8.1 Found Poetry - Let´s Check your Understanding!", time: 1, unit: "English")
    project8.topics.create!(name: "8.2 The Red Tree", time: 1, unit: "English")
    project8.topics.create!(name: "8.2 Everyone Loves Ava... - Let´s Check your Understanding!", time: 1, unit: "English")
    project8.topics.create!(name: "8.3 All things Grammar: The Passive Voice", time: 1, unit: "English")
    project8.topics.create!(name: "8.3 The Passive Voice Meme - Let´s Check your Understanding!", time: 1, unit: "English")
    project8.topics.create!(name: "Let's Practise - Probabilities", time: 1, unit: "Mathematics")
    project8.topics.create!(name: "Let's Practise - Relative Frequency Quiz", time: 1, unit: "Mathematics")
    project8.topics.create!(name: "Let's Practise - Pie charts", time: 1, unit: "Mathematics")
    project8.topics.create!(name: "Let's Practise - Pictogram Quiz", time: 1, unit: "Mathematics")
    project8.topics.create!(name: "Let's Practise - Frequency Polygons Quiz", time: 1, unit: "Mathematics")
    project8.topics.create!(name: "Let's Practise - Averages Quiz", time: 1, unit: "Mathematics")
    project8.topics.create!(name: "Let's Practise - Back to back Stem-and-Leaf Diagram Quiz", time: 1, unit: "Mathematics")
    project8.topics.create!(name: "Let's check your Understanding - Cross Topic Quiz Statistics", time: 1, unit: "Mathematics")
    project8.topics.create!(name: "Let's check your Understanding - Cross Topic Quiz Probability", time: 1, unit: "Mathematics")
    project8.topics.create!(name: "Mathematics Probability and Statistics Checkpoint", time: 1, unit: "Mathematics")

  project9 = Subject.create!(
    name: "P9 - Life on Land - LWS Y8",
    category: :lws,
    )

    project9.topics.create!(name: "9.1 Introduction", time: 1, unit: "Learning Through Research")
    project9.topics.create!(name: "9.2 Nature's Puzzle: Protecting Life's Wonders", time: 1, unit: "Learning Through Research")
    project9.topics.create!(name: "9.3 Guardians of the Canopy: One Man's Tree-Saving Mission", time: 1, unit: "Learning Through Research")
    project9.topics.create!(name: "Final Project: Becoming an SDG 15 Warrior - Let´s Check your Understanding!", time: 1, unit: "Learning Through Research")
    project9.topics.create!(name: "9.1 Information Texts", time: 1, unit: "English")
    project9.topics.create!(name: "9.1 Information Text - Let´s Check your Understanding!", time: 1, unit: "English")
    project9.topics.create!(name: "9.2 Strategies for Tricky Words", time: 1, unit: "English")
    project9.topics.create!(name: "9.2 Word Wizard Adventure - Let´s Check your Understanding!", time: 1, unit: "English")
    project9.topics.create!(name: "9.3 All things Grammar", time: 1, unit: "English")
    project9.topics.create!(name: "9.3 Conjunction Explorer - Let´s Check your Understanding!", time: 1, unit: "English")
    project9.topics.create!(name: "English— 100% Progression Test Submission", time: 1, unit: "English")
    project9.topics.create!(name: "Numbers checkpoint - Unlimited Attempts", time: 1, unit: "Maths")
    project9.topics.create!(name: "Algebra checkpoint - Unlimited Attempts", time: 1, unit: "Maths")
    project9.topics.create!(name: "Geometry checkpoint - Unlimited Attempts", time: 1, unit: "Maths")
    project9.topics.create!(name: "Probability & Statistics checkpoint - Unlimited Attempts", time: 1, unit: "Maths")
    project9.topics.create!(name: "Let's Practise 100% Progression MODEL 1", time: 1, unit: "Maths")
    project9.topics.create!(name: "Let's Practise 100% Progression MODEL 2", time: 1, unit: "Maths")
    project9.topics.create!(name: "Mathematics Progression test Updated 2024", time: 1, unit: "Maths")
    project9.topics.create!(name: "9.1 Plants", time: 1, unit: "Science")
    project9.topics.create!(name: "9.2 Respiration", time: 1, unit: "Science")
    project9.topics.create!(name: "Project 9 — Let's Check your Understanding!", time: 1, unit: "Science")
    project9.topics.create!(name: "Year 8 - Study Plan", time: 1, unit: "Science")
    project9.topics.create!(name: "Science — 100% Progression Test Submission", time: 1, unit: "Science")
    project9.topics.create!(name: "9.1 Artigo de Opinião", time: 1, unit: "Português")
    project9.topics.create!(name: "9.1 Let's Check your Understanding! - Artigo de Opinião", time: 1, unit: "Português")
    project9.topics.create!(name: "9.2 O autorretrato", time: 1, unit: "Português")
    project9.topics.create!(name: "9.2 Let's Check your Understanding! - O autorretrato", time: 1, unit: "Português")
    project9.topics.create!(name: "Português — 100% Progression Test Submission", time: 1, unit: "Português")


testhub = Hub.create!(
  name: "Test Hub",
  country: "Portugal"
  )

  Hub.create!(
    name: "Aveiro",
    country: "Portugal"
)
Hub.create!(
    name: "Bangalore (Micro)",
    country: "India"
)
Hub.create!(
    name: "Boca Raton",
    country: "USA"
)
Hub.create!(
    name: "Braga",
    country: "Portugal"
)
Hub.create!(
    name: "Caldas da Rainha",
    country: "Portugal"
)
Hub.create!(
    name: "Campolide",
    country: "Portugal"
)
Hub.create!(
    name: "Cascais 1",
    country: "Portugal"
)
Hub.create!(
    name: "Cascais 2",
    country: "Portugal"
)
Hub.create!(
    name: "Cascais Baía 1",
    country: "Portugal"
)
Hub.create!(
    name: "Cascais Baía 2",
    country: "Portugal"
)
Hub.create!(
    name: "CCB",
    country: "Portugal"
)
Hub.create!(
    name: "Coimbra (Espinhal)",
    country: "Portugal"
)
Hub.create!(
    name: "Ericeira 1",
    country: "Portugal"
)
Hub.create!(
    name: "Ericeira 2",
    country: "Portugal"
)
Hub.create!(
    name: "Expo",
    country: "Portugal"
)
Hub.create!(
    name: "Funchal",
    country: "Portugal"
)
Hub.create!(
    name: "Fundão",
    country: "Portugal"
)
Hub.create!(
    name: "Guincho",
    country: "Portugal"
)
Hub.create!(
    name: "Kilifi",
    country: "Kenya"
)
Hub.create!(
    name: "Lagoa",
    country: "Portugal"
)
Hub.create!(
    name: "Lagos 1",
    country: "Portugal"
)
Hub.create!(
    name: "Lagos 2",
    country: "Portugal"
)
Hub.create!(
    name: "Leiria",
    country: "Portugal"
)
Hub.create!(
    name: "Loulé",
    country: "Portugal"
)
Hub.create!(
    name: "Lumiar",
    country: "Portugal"
)
Hub.create!(
    name: "Marbella",
    country: "Spain"
)
Hub.create!(
    name: "Nelspruit",
    country: "South Africa"
)
Hub.create!(
    name: "Óbidos",
    country: "Portugal"
)
Hub.create!(
    name: "Ofir",
    country: "Portugal"
)
Hub.create!(
    name: "Online",
    country: "Portugal"
)
Hub.create!(
    name: "Parede",
    country: "Portugal"
)
Hub.create!(
    name: "Phuket",
    country: "Thailand"
)
Hub.create!(
    name: "Porto Anje",
    country: "Portugal"
)
Hub.create!(
    name: "Porto Foco",
    country: "Portugal"
)
Hub.create!(
    name: "Quinta da Marinha",
    country: "Portugal"
)
Hub.create!(
    name: "Restelo",
    country: "Portugal"
)
Hub.create!(
    name: "Santarém",
    country: "Portugal"
)
Hub.create!(
    name: "Setúbal",
    country: "Portugal"
)
Hub.create!(
    name: "Sommerschield",
    country: "Mozambique"
)
Hub.create!(
    name: "Tábua",
    country: "Portugal"
)
Hub.create!(
    name: "Tavira",
    country: "Portugal"
)
Hub.create!(
    name: "Tofo",
    country: "Mozambique"
)
Hub.create!(
    name: "Tygervalley",
    country: "South Africa"
)
Hub.create!(
    name: "Valencia",
    country: "Spain"
)
Hub.create!(
    name: "Vila Sol",
    country: "Portugal"
)
Hub.create!(
    name: "Walvis Bay",
    country: "Namibia"
)
Hub.create!(
    name: "Windhoek",
    country: "Namibia"
)
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

  tester_hub = UsersHub.create!(
    user: tester,
    hub: testhub
    )

  guest_lc = User.create!(
    email: "guest@lc.com",
    password: "123456",
    full_name: "Guest LC",
    role: "lc"
    )


  cascais_lc = User.create!(
    email: "cascais@lc.com",
    password: "123456",
    full_name: "Cascais LC",
    role: "lc"
    )

  UsersHub.create!(
    user: cascais_lc,
    hub: testhub
    )

      cascais_learner = User.create!(
        email: "cascais@learner.com",
        password: "123456",
        full_name: "Guest 1",
        role: "learner"
        )

        UsersHub.create!(
          user: cascais_learner,
          hub: testhub
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


  guest_lc  = UsersHub.create!(
    user: guest_lc,
    hub: testhub
  )

    xico_hub = UsersHub.create!(
      user: xico,
      hub: testhub
      )
    brito_hub = UsersHub.create!(
      user: brito,
      hub: testhub
    )

      mary_hub = UsersHub.create!(
      user: mary,
      hub: testhub
      )

      quim_hub = UsersHub.create!(
      user: quim,
      hub: testhub
      )

      Holiday.create!(
        name: "Easter Break 2024",
        start_date: "2024/03/25",
        end_date: "2024/04/01",
        bga: true
      )

      Holiday.create!(
        name: "Easter Break 2024",
        start_date: "2024/03/25",
        end_date: "2024/04/01",
        user: brito
      )

      Holiday.create!(
        name: "Christmas Break 2024",
        start_date: "2024/12/16",
        end_date: "2025/01/02",
        bga: true
      )

      sprint1 = Sprint.create!(
        name: "Sprint 1",
        start_date: "04/01/2024",
        end_date: "03/05/2024"
      )

      sprint2 = Sprint.create!(
        name: "Sprint 2",
        start_date: "06/05/2024",
        end_date: "30/08/2024"
      )

      sprint3 = Sprint.create!(
        name: "Sprint 3",
        start_date: "02/09/2024",
        end_date: "03/01/2025"
      )

      Week.create!(
        name: "Week 8",
        start_date: "04/03/2024",
        end_date: "11/03/2024",
        sprint_id: sprint1
      )
      Week.create!(
        name: "Week 9",
        start_date: "11/03/2024",
        end_date: "18/03/2024",
        sprint_id: sprint1
      )
      Week.create!(
        name: "Week 10",
        start_date: "18/03/2024",
        end_date: "25/03/2024",
        sprint_id: sprint1
      )

      Week.create!(
        name: "Week 11",
        start_date: "01/04/2024",
        end_date: "08/04/2024",
        sprint_id: sprint1
      )

      Week.create!(
        name: "Week 12",
        start_date: "08/04/2024",
        end_date: "15/04/2024",
        sprint_id: sprint1
      )

      Week.create!(
        name: "Week 13",
        start_date: "15/04/2024",
        end_date: "22/04/2024",
        sprint_id: sprint1
      )
      Week.create!(
        name: "Week 14",
        start_date: "22/04/2024",
        end_date: "29/04/2024",
        sprint_id: sprint1
      )
      Week.create!(
        name: "Week 15",
        start_date: "29/04/2024",
        end_date: "06/05/2024",
        sprint_id: sprint1
      )

      Week.create!(
      name: "Week 16",
      start_date: "15/04/2024",
      end_date: "19/04/2024",
      sprint_id: sprint1
      )
      Week.create!(
      name: "Week 17",
      start_date: "22/04/2024",
      end_date: "26/04/2024",
      sprint_id: sprint1
      )
      Week.create!(
      name: "Week 18",
      start_date: "29/04/2024",
      end_date: "03/05/2024",
      sprint_id: sprint1
      )
      Week.create!(
      name: "Week 1",
      start_date: "06/05/2024",
      end_date: "10/05/2024",
      sprint_id: sprint2
      )
      Week.create!(
      name: "Week 2",
      start_date: "13/05/2024",
      end_date: "17/05/2024",
      sprint_id: sprint2
      )
      Week.create!(
      name: "Week 3",
      start_date: "20/05/2024",
      end_date: "24/05/2024",
      sprint_id: sprint2
      )
      Week.create!(
      name: "Week 4",
      start_date: "27/05/2024",
      end_date: "31/05/2024",
      sprint_id: sprint2
      )
      Week.create!(
      name: "Week 5",
      start_date: "03/06/2024",
      end_date: "07/06/2024",
      sprint_id: sprint2
      )
      Week.create!(
      name: "Week 6",
      start_date: "10/06/2024",
      end_date: "14/06/2024",
      sprint_id: sprint2
      )
      Week.create!(
      name: "Week 7",
      start_date: "17/06/2024",
      end_date: "21/06/2024",
      sprint_id: sprint2
      )
      Week.create!(
      name: "Week 8",
      start_date: "24/06/2024",
      end_date: "28/06/2024",
      sprint_id: sprint2
      )
      Week.create!(
      name: "Week 9",
      start_date: "01/07/2024",
      end_date: "05/07/2024",
      sprint_id: sprint2
      )
      Week.create!(
      name: "Week 10",
      start_date: "08/07/2024",
      end_date: "12/07/2024",
      sprint_id: sprint2
      )
      Week.create!(
      name: "Week 11",
      start_date: "15/07/2024",
      end_date: "19/07/2024",
      sprint_id: sprint2
      )
      Week.create!(
      name: "Week 12",
      start_date: "22/07/2024",
      end_date: "26/07/2024",
      sprint_id: sprint2
      )
      Week.create!(
      name: "Week 13",
      start_date: "29/07/2024",
      end_date: "02/08/2024",
      sprint_id: sprint2
      )
      Week.create!(
      name: "Week 14",
      start_date: "05/08/2024",
      end_date: "09/08/2024",
      sprint_id: sprint2
      )
      Week.create!(
      name: "Week 15",
      start_date: "12/08/2024",
      end_date: "16/08/2024",
      sprint_id: sprint2
      )
      Week.create!(
      name: "Week 16",
      start_date: "19/08/2024",
      end_date: "23/08/2024",
      sprint_id: sprint2
      )
      Week.create!(
      name: "Week 17",
      start_date: "26/08/2024",
      end_date: "30/08/2024",
      sprint_id: sprint2
      )
      Week.create!(
      name: "Week 1",
      start_date: "02/09/2024",
      end_date: "06/09/2024",
      sprint_id: sprint3
      )
      Week.create!(
      name: "Week 2",
      start_date: "09/09/2024",
      end_date: "13/09/2024",
      sprint_id: sprint3
      )
      Week.create!(
      name: "Week 3",
      start_date: "16/09/2024",
      end_date: "20/09/2024",
      sprint_id: sprint3
      )
      Week.create!(
      name: "Week 4",
      start_date: "23/09/2024",
      end_date: "27/09/2024",
      sprint_id: sprint3
      )
      Week.create!(
      name: "Week 5",
      start_date: "30/09/2024",
      end_date: "04/10/2024",
      sprint_id: sprint3
      )
      Week.create!(
      name: "Week 6",
      start_date: "07/10/2024",
      end_date: "11/10/2024",
      sprint_id: sprint3
      )
      Week.create!(
      name: "Week 7",
      start_date: "14/10/2024",
      end_date: "18/10/2024",
      sprint_id: sprint3
      )
      Week.create!(
      name: "Week 8",
      start_date: "21/10/2024",
      end_date: "25/10/2024",
      sprint_id: sprint3
      )
      Week.create!(
      name: "Week 9",
      start_date: "28/10/2024",
      end_date: "01/11/2024",
      sprint_id: sprint3
      )
      Week.create!(
      name: "Week 10",
      start_date: "04/11/2024",
      end_date: "08/11/2024",
      sprint_id: sprint3
      )
      Week.create!(
      name: "Week 11",
      start_date: "11/11/2024",
      end_date: "15/11/2024",
      sprint_id: sprint3
      )
      Week.create!(
      name: "Week 12",
      start_date: "18/11/2024",
      end_date: "22/11/2024",
      sprint_id: sprint3
      )
      Week.create!(
      name: "Week 13",
      start_date: "25/11/2024",
      end_date: "29/11/2024",
      sprint_id: sprint3
      )
      Week.create!(
      name: "Week 14",
      start_date: "02/12/2024",
      end_date: "06/12/2024",
      sprint_id: sprint3
      )
      Week.create!(
      name: "Week 15",
      start_date: "09/12/2024",
      end_date: "13/12/2024",
      sprint_id: sprint3
      )
      Week.create!(
      name: "Week 16",
      start_date: "16/12/2024",
      end_date: "20/12/2024",
      sprint_id: sprint3
      )



end
