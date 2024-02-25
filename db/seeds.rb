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

english_a_level = Subject.create!(
  name: "English A Level",
  category: :al,
)

english_a_level.topics.create!(name: "Introduction to the Course", time: 1)
english_a_level.topics.create!(name: "Pre-course", time: 1)
english_a_level.topics.create!(name: "Topic 1.1 Introduction to Methods of proof", time: 4, unit: "Unit 1: Proof")
english_a_level.topics.create!(name: "Topic 1.2 - Proof by Contradiction", time: 3, unit: "Unit 1: Proof")
english_a_level.topics.create!(name: "Topic 2.1 Algebraic Expressions, Indices and Surds", time: 4, unit: "Unit 2: Algebra and Functions")
english_a_level.topics.create!(name: "Topic 2.2 Quadratics", time: 5, unit: "Unit 2: Algebra and Functions")
english_a_level.topics.create!(name: "Topic 2.3 -  Simultaneous Equations", time: 4, unit: "Unit 2: Algebra and Functions")
english_a_level.topics.create!(name: "Topic 2.4 - Inequalities", time: 6, unit: "Unit 2: Algebra and Functions")
english_a_level.topics.create!(name: "Topic 2.5 - Polynomial and Reciprocal Functions", time: 5, unit: "Unit 2: Algebra and Functions")
english_a_level.topics.create!(name: "Topic 2.6 - Transformations and Symmetries", time: 6, unit: "Unit 2: Algebra and Functions")
english_a_level.topics.create!(name: "Topic 2.7 - Algebraic Division", time: 4, unit: "Unit 2: Algebra and Functions")
english_a_level.topics.create!(name: "End of Unit Assessments", time: 3, unit: "Unit 2: Algebra and Functions", has_grade: true)
english_a_level.topics.create!(name: "Topic 2.8 - Algebraic Fraction Manipulation", time: 2, unit: "Unit 2: Algebra and Functions")
english_a_level.topics.create!(name: "Topic 2.9 - Partial Fractions", time: 4, unit: "Unit 2: Algebra and Functions")
english_a_level.topics.create!(name: "Topic 2.10 - Composite and Inverse Functions", time: 4, unit: "Unit 2: Algebra and Functions")
english_a_level.topics.create!(name: "Topic 2.11 - Modulus Function", time: 5, unit: "Unit 2: Algebra and Functions")
english_a_level.topics.create!(name: "Topic 2.12 - Composite Transformations", time: 3, unit: "Unit 2: Algebra and Functions")
english_a_level.topics.create!(name: "End of Unit Assessments", time: 3, unit: "Unit 2: Algebra and Functions", has_grade: true)
english_a_level.topics.create!(name: "Topic 3.1 - Coordinate Geometry of Straigh Lines", time: 6, unit: "Unit 3: Coordinate Geometry")
english_a_level.topics.create!(name: "Topic 3.2 - Coordinate Geometry of Circles", time: 8, unit: "Unit 3: Coordinate Geometry")
english_a_level.topics.create!(name: "Topic 3.3 - Parametric Equations", time: 3, unit: "Unit 3: Coordinate Geometry")
english_a_level.topics.create!(name: "End of Unit Assessments", time: 1, unit: "Unit 3: Coordinate Geometry", has_grade: true)
english_a_level.topics.create!(name: "Topic 4.1. Arithmetic Sequences and Series", time: 2, unit: "Unit 4: Sequences, Series and Binomial Expansion")
english_a_level.topics.create!(name: "Topic 4.2.  Geometric Sequences and Series", time: 3, unit: "Unit 4: Sequences, Series and Binomial Expansion")
english_a_level.topics.create!(name: "Topic 4.3 - General Sequences, Series and Notation", time: 5, unit: "Unit 4: Sequences, Series and Binomial Expansion")
english_a_level.topics.create!(name: "Topic 4.4 - Binomial Expansion for Positive Integer Exponents", time: 7, unit: "Unit 4: Sequences, Series and Binomial Expansion")

economics_a_level = Subject.create!(
  name: "Economics A Level",
  category: :al,
)

economics_a_level.topics.create!(name: "Introduction to the Course", time: 1)
economics_a_level.topics.create!(name: "Pre-course", time: 1)
economics_a_level.topics.create!(name: "Topic 1.1 Introduction to Methods of proof", time: 4, unit: "Unit 1: Proof")
economics_a_level.topics.create!(name: "Topic 1.2 - Proof by Contradiction", time: 3, unit: "Unit 1: Proof")
economics_a_level.topics.create!(name: "Topic 2.1 Algebraic Expressions, Indices and Surds", time: 4, unit: "Unit 2: Algebra and Functions")
economics_a_level.topics.create!(name: "Topic 2.2 Quadratics", time: 5, unit: "Unit 2: Algebra and Functions")
economics_a_level.topics.create!(name: "Topic 2.3 -  Simultaneous Equations", time: 4, unit: "Unit 2: Algebra and Functions")
economics_a_level.topics.create!(name: "Topic 2.4 - Inequalities", time: 6, unit: "Unit 2: Algebra and Functions")
economics_a_level.topics.create!(name: "Topic 2.5 - Polynomial and Reciprocal Functions", time: 5, unit: "Unit 2: Algebra and Functions")
economics_a_level.topics.create!(name: "Topic 2.6 - Transformations and Symmetries", time: 6, unit: "Unit 2: Algebra and Functions")
economics_a_level.topics.create!(name: "Topic 2.7 - Algebraic Division", time: 4, unit: "Unit 2: Algebra and Functions")
economics_a_level.topics.create!(name: "End of Unit Assessments", time: 3, unit: "Unit 2: Algebra and Functions", has_grade: true)
economics_a_level.topics.create!(name: "Topic 2.8 - Algebraic Fraction Manipulation", time: 2, unit: "Unit 2: Algebra and Functions")
economics_a_level.topics.create!(name: "Topic 2.9 - Partial Fractions", time: 4, unit: "Unit 2: Algebra and Functions")
economics_a_level.topics.create!(name: "Topic 2.10 - Composite and Inverse Functions", time: 4, unit: "Unit 2: Algebra and Functions")
economics_a_level.topics.create!(name: "Topic 2.11 - Modulus Function", time: 5, unit: "Unit 2: Algebra and Functions")

xico = User.create!(
  email: "francisco-abf@hotmail.com",
  password: "123456",
  full_name: "Francisco Figueiredo",
  role: :admin
  )

joe = User.create!(
  email: "john@learner.com",
  password: "123456",
  full_name: "Joe King",
  role: :learner
  )

mary = User.create!(
  email: "mary@learner.com",
  password: "123456",
  full_name: "Mary Queen",
  role: :learner
  )

manel = User.create!(
  email: "manel@learner.com",
  password: "123456",
  full_name: "Manel Costa",
  role: :learner
  )

quim = User.create!(
  email: "quim@learner.com",
  password: "123456",
  full_name: "Quim Barreiros",
  role: :learner
  )


  porto = Hmaryub.create!(
    name: "porto",
    country: "Portugal"
    )

  cascais = Hub.create!(
    name: "Cascais",
    country: "Portugal"
    )

    xico_hub = UsersHub.create!(
      user: xico,
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


      math_a_level.topics.each do |topic|
        UserTopic.create!(
          user: xico,
          topic: topic
        )

        UserTopic.create!(
          user: joe,
          topic: topic
        )

        UserTopic.create!(
          user: mary,
          topic: topic
        )

        UserTopic.create!(
          user: manel,
          topic: topic
        )

        UserTopic.create!(
          user: quim,
          topic: topic
        )
      end

      english_a_level.topics.each do |topic|
        UserTopic.create!(
          user: xico,
          topic: topic
        )

        UserTopic.create!(
          user: joe,
          topic: topic
        )

        UserTopic.create!(
          user: mary,
          topic: topic
        )

        UserTopic.create!(
          user: manel,
          topic: topic
        )

        UserTopic.create!(
          user: quim,
          topic: topic
        )
      end

      economics_a_level.topics.each do |topic|
        UserTopic.create!(
          user: xico,
          topic: topic
        )

        UserTopic.create!(
          user: joe,
          topic: topic
        )

        UserTopic.create!(
          user: mary,
          topic: topic
        )

        UserTopic.create!(
          user: manel,
          topic: topic
        )

        UserTopic.create!(
          user: quim,
          topic: topic
        )
      end
