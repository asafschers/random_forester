# frozen_string_literal: true

require 'spec_helper'

describe Scoruby::Models::RandomForest::Model do
  let(:rf_file) { 'spec/fixtures/titanic_rf.pmml' }
  let(:xml) { Scoruby.xml_from_file_path(rf_file) }
  let(:random_forest) { described_class.new(xml) }
  let(:prediction) { random_forest.score(features) }
  let(:decisions_count) { random_forest.decisions_count(features) }

  context '0 features' do
    let(:features) do
      {
        Sex: 'male',
        Parch: 0,
        Age: 30,
        Fare: 9.6875,
        Pclass: 2,
        SibSp: 0,
        Embarked: 'Q'
      }
    end
    it 'predicts 0' do
      expect(prediction[:label]).to eq '0'
      expect(prediction[:score]).to eq 13 / 15.to_f
      expect(decisions_count['0']).to eq 13
      expect(decisions_count['1']).to eq 2
    end
  end

  context '1 features' do
    let(:features) do
      {
        Sex: 'female',
        Parch: 0,
        Age: 38,
        Fare: 71.2833,
        Pclass: 2,
        SibSp: 1,
        Embarked: 'C'
      }
    end

    it 'predicts 0' do
      expect(prediction[:label]).to eq '1'
      expect(prediction[:score]).to eq 14 / 15.to_f
      expect(decisions_count['0']).to eq 1
      expect(decisions_count['1']).to eq 14
    end
  end

  context 'regression' do
    let(:rf_file) { 'spec/fixtures/cars_rf.pmml' }
    let(:features) do
      {
        speed: 10
      }
    end

    it 'predicts correctly' do
      expect(prediction[:response]).to be_within(0.001).of(27.37778)
    end
  end
end
