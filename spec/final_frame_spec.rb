require 'final_frame'

describe FinalFrame do
  let(:roll) { double(:roll) }

  context 'the default frame' do
    it { is_expected.to have_attributes(pins: 10) }

    it { is_expected.to respond_to(:rolls) }
  end

  context '#ended?' do
    it 'defaults to false' do
      expect(subject).not_to be_ended
    end

    it 'can end the frame' do
      allow(roll).to receive(:pins).and_return(1)
      subject.add(roll)
      subject.add(roll)
      expect(subject).to be_ended
    end

    it 'does not end the frame if there is a spare' do
      allow(roll).to receive(:pins).and_return(5)
      subject.add(roll)
      subject.add(roll)
      
      expect(subject).not_to be_ended
    end

    xit 'does not end the frame for a strike' do
      allow(roll).to receive(:pins).and_return(10)
      subject.add(roll)
      expect(subject).not_to be_ended
      subject.add(roll)
      expect(subject).not_to be_ended
    end
  end

  context '#add' do
    it 'can store rolls' do
      allow(roll).to receive(:pins).and_return(5)
      subject.add(roll)
      expect(subject.rolls).to eq [roll]
    end

    it 'can deduct pins by the amount rolled over' do
      allow(roll).to receive(:pins).and_return(5)
      subject.add(roll)
      expect(subject.pins).to eq 5
    end

    it 'can store a second roll' do
      allow(roll).to receive(:pins).and_return(1)
      subject.add(roll)
      subject.add(roll)

      expect(subject.rolls).to eq [roll, roll]
    end

    it 'resets the frame after a strike' do
      allow(roll).to receive(:pins).and_return(10)
      subject.add(roll)

      expect(subject.pins).to eq 10
    end
  end

  context '#score' do
    it 'can score a frame' do
      allow(roll).to receive(:pins).and_return(1)
      subject.add(roll)
      subject.add(roll)

      expect(subject.score).to eq 2
    end
  end

  context '#spare?' do
    it 'can identify a spare' do
      allow(roll).to receive(:pins).and_return(5)
      subject.add(roll)
      subject.add(roll)

      expect(subject).to be_spare
    end
  end

  context '#strike?' do
    it 'can identify a strike' do
      allow(roll).to receive(:pins).and_return(10)
      subject.add(roll)

      expect(subject).to be_strike
      expect(subject).not_to be_spare
    end
  end
end