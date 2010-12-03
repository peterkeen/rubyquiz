#!/usr/bin/env ruby

class Person
  attr_accessor :first_name, :family_name, :email, :santa

  def initialize(first, family, email)
    @first_name  = first
    @family_name = family
    @email       = email
  end

  def self.parse(line)
    line.chomp!
    first, family, email = line.split /\s+/
    return self.new(first, family, email)
  end

  def has_santa?
    return self.santa
  end

  def to_s
    "#{@first_name} #{@family_name} #{@email}"
  end
end

class SecretSanta
  attr_accessor :people

  def initialize
    @people = {}
    @pairs = []
  end

  def add_person(person)
    self.people[ person.family_name ] ||= []
    self.people[ person.family_name ].push person
  end

  def assign
    self.people.keys.each do |family|
      @pairs = @pairs + play_family(family)
    end
  end

  def play_family(family_name)
    other_families = self.people.keys.reject { |f| f == family_name }

    other_people = other_families.inject([]) { |a, f|  a + self.people[f] }

    pairs = []

    self.people[family_name].each do |p|
      santa = other_people.reject { |o| o.has_santa? }.shuffle.first
      santa.santa = 1
      pairs = pairs.push [p, santa]
    end

    return pairs
  end

  def inform
    @pairs.each do |pair|
      send_email(pair[0], pair[1])
    end
  end

  def send_email(person, santa)
    puts "Sending email to #{person} informing them of their santa: #{santa}"
  end
  
end


game = SecretSanta.new

ARGF.each do |line|
  game.add_person Person.parse line
end

game.assign
game.inform

